import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ugflix/models/NewMovieModel.dart';
import 'package:ugflix/utils/CustomTheme.dart';
import 'package:ugflix/utils/Utilities.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Map<String, dynamic> params;
  const VideoPlayerScreen(this.params, {Key? key}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with WidgetsBindingObserver {
  late VideoPlayerController _ctrl;
  bool _inited = false;
  bool _showOverlay = true;
  bool _locked = false;
  bool _showSettings = false;
  bool _uploading = false;
  bool _pageActive = true;

  Timer? _hideTimer, _uploadTimer;

  static const int skipSeconds = 10;

  // continuous sliders
  double _currentSpeed = 1.0;
  double _currentVolume = 1.0;

  late NewMovieModel movie;

  @override
  void initState() {
    super.initState();
    movie = widget.params['video_item'] as NewMovieModel;
    WidgetsBinding.instance.addObserver(this);
    _enterFullscreen();
    WakelockPlus.enable();
    _initVideo();
  }

  Future<void> _initVideo() async {
    _ctrl = VideoPlayerController.network(movie.get_video_url());
    try {
      await _ctrl.initialize();

      // Resume prompt if >30s watched before
      int saved = Utils.int_parse(movie.watch_progress);
      if (saved > 30 && saved < _ctrl.value.duration.inSeconds) {
        final pos = Duration(seconds: saved);
        Get.rawSnackbar(
          messageText: Text("Resume at ${_format(pos)}?",
              style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.black87,
          mainButton: TextButton(
            child: const Text("Yes", style: TextStyle(color: Colors.yellow)),
            onPressed: () {
              _ctrl.seekTo(pos);
              Get.back();
            },
          ),
          duration: const Duration(seconds: 3),
        );
      }

      // set initial volume & speed
      await _ctrl.setVolume(_currentVolume);
      await _ctrl.setPlaybackSpeed(_currentSpeed);
      _ctrl.play();
      setState(() => _inited = true);
      _startUploadTimer();
      _startHideTimer();
    } catch (_) {
      Utils.toast("Failed to load video.");
      Get.back();
    }
    _ctrl.setLooping(false);
  }

  void _enterFullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _exitFullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  void _startHideTimer() {
    if (_locked || _showSettings) return;
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() => _showOverlay = false);
    });
  }

  void _toggleOverlay() {
    if (_locked || _showSettings) return;
    setState(() => _showOverlay = !_showOverlay);
    if (_showOverlay) _startHideTimer();
  }

  void _startUploadTimer() {
    _uploadTimer?.cancel();
    _uploadTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_pageActive) _uploadProgress();
    });
  }

  Future<void> _uploadProgress({bool finalUpload = false}) async {
    if (!_inited || _uploading) return;
    _uploading = true;
    int pos = _ctrl.value.position.inSeconds;
    int total = _ctrl.value.duration.inSeconds;
    int saved = Utils.int_parse(movie.watch_progress);
    if (finalUpload || (pos - saved).abs() >= 5) {
      movie.watch_progress = pos.toString();
      movie.max_progress = total.toString();
      movie.watch_status = 'Active';
      movie.watched_movie = 'Yes';
      await movie.submitViewProgress(pos, total);
    }
    _uploading = false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageActive = false;
    _uploadTimer?.cancel();
    _hideTimer?.cancel();
    _uploadProgress(finalUpload: true);
    _ctrl.dispose();
    _exitFullscreen();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_inited) return;
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _pageActive = false;
      _ctrl.pause();
    } else if (state == AppLifecycleState.resumed) {
      _pageActive = true;
      _ctrl.play();
      _startUploadTimer();
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Exit Playback?"),
            content: const Text("Are you sure you want to leave?"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("No")),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Yes")),
            ],
          ),
        )) ??
        false;
  }

  void _playPause() {
    if (!_inited) return;
    if (_ctrl.value.isPlaying) {
      _ctrl.pause();
    } else {
      _ctrl.play();
      _startUploadTimer();
    }
    setState(() {});
  }

  void _skip(int seconds) {
    if (!_inited) return;
    final curr = _ctrl.value.position;
    var target = curr + Duration(seconds: seconds);
    if (target < Duration.zero) target = Duration.zero;
    if (target > _ctrl.value.duration) target = _ctrl.value.duration;
    _ctrl.seekTo(target);
  }

  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    if (d.inHours > 0) {
      return "${d.inHours}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}";
    }
    return "${two(d.inMinutes)}:${two(d.inSeconds)}";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: _toggleOverlay,
          child: Stack(children: [
            Center(
              child: _inited
                  ? AspectRatio(
                      aspectRatio: _ctrl.value.aspectRatio,
                      child: VideoPlayer(_ctrl),
                    )
                  : _buildLoadingOverlay(),
            ),

            /// Overlays
            if (_showOverlay) ...[
              _buildOverlay(),
              if (_showSettings) _buildSettingsPanel(),
            ],
          ]),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    final thumb =
        movie.thumbnail_url.isNotEmpty ? movie.thumbnail_url : movie.image_url;
    return Stack(fit: StackFit.expand, children: [
      if (thumb.isNotEmpty)
        CachedNetworkImage(
          imageUrl: thumb,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(color: Colors.black),
          errorWidget: (_, __, ___) => Container(color: Colors.black),
        ),
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(color: Colors.black54),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(
            width: 60,
            height: 60,
            child:
                CircularProgressIndicator(strokeWidth: 5, color: Colors.yellow),
          ),
          SizedBox(height: 12),
          Text("Loading...",
              style: TextStyle(color: Colors.white70, fontSize: 16)),
        ],
      ),
    ]);
  }

  Widget _buildOverlay() {
    if (_locked) {
      return Center(
        child: IconButton(
          iconSize: 50,
          color: Colors.white70,
          icon: const Icon(Icons.lock_outline),
          onPressed: () {
            setState(() => _locked = false);
            _startHideTimer();
          },
        ),
      );
    }
    return Positioned.fill(
      child: Container(
        color: Colors.black38,
        child: Column(
          children: [
            SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () async {
                      if (await _onWillPop()) Get.back();
                    },
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      _locked ? Icons.lock : Icons.lock_open,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() => _locked = !_locked);
                      if (!_locked) _startHideTimer();
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 40,
                  color: Colors.white,
                  icon: const Icon(Icons.replay_10),
                  onPressed: () => _skip(-skipSeconds),
                ),
                IconButton(
                  iconSize: 60,
                  color: Colors.white,
                  icon: Icon(_ctrl.value.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled),
                  onPressed: _playPause,
                ),
                IconButton(
                  iconSize: 40,
                  color: Colors.white,
                  icon: const Icon(Icons.forward_10),
                  onPressed: () => _skip(skipSeconds),
                ),
              ],
            ),
            const Spacer(),
            Container(
              color: Colors.black45,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Text(_format(_ctrl.value.position),
                      style: const TextStyle(color: Colors.white)),
                  Expanded(
                    child: VideoProgressIndicator(
                      _ctrl,
                      allowScrubbing: true,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      colors: VideoProgressColors(
                        playedColor: CustomTheme.accent,
                        bufferedColor: Colors.white30,
                        backgroundColor: Colors.white12,
                      ),
                    ),
                  ),
                  Text(_format(_ctrl.value.duration),
                      style: const TextStyle(color: Colors.white)),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _showSettings = true;
                        _showOverlay = true;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsPanel() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          setState(() => _showSettings = false);
          _startHideTimer();
        },
        child: Container(
          color: Colors.black54,
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {}, // consume
            child: Container(
              width: 300,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text("Playback Speed: ${_currentSpeed.toStringAsFixed(1)}×",
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 16)),
                Slider(
                  value: _currentSpeed,
                  min: 0.5,
                  max: 2.0,
                  divisions: 15,
                  activeColor: Colors.yellow,
                  inactiveColor: Colors.white24,
                  onChanged: (v) {
                    setState(() {
                      _currentSpeed = v;
                      _ctrl.setPlaybackSpeed(v);
                    });
                  },
                ),
                const SizedBox(height: 8),
                Text("Volume: ${(_currentVolume * 100).round()}%",
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 16)),
                Slider(
                  value: _currentVolume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  activeColor: Colors.yellow,
                  inactiveColor: Colors.white24,
                  onChanged: (v) {
                    setState(() {
                      _currentVolume = v;
                      _ctrl.setVolume(v);
                    });
                  },
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: const Text("Done",
                        style: TextStyle(color: Colors.yellow)),
                    onPressed: () {
                      setState(() => _showSettings = false);
                      _startHideTimer();
                    },
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
