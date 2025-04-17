import 'dart:async';
import 'dart:math';
import 'dart:ui'; // For BackdropFilter

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:ugflix/utils/CustomTheme.dart'; // Your custom colors
import 'package:ugflix/utils/Utilities.dart'; // Utilities like Utils.toast(), Utils.int_parse()
import '../../models/NewMovieModel.dart'; // Your movie model

/// This screen uses Chewie for video playback and includes custom controls,
/// progress uploading, and lifecycle management.
class VideoPlayerScreen extends StatefulWidget {
  final Map<String, dynamic> params;

  const VideoPlayerScreen(this.params, {Key? key}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;

  // Reactive variables for UI state.
  final RxBool _videoInitialized = false.obs;
  final RxBool _showLoading = true.obs;
  final RxBool _showError = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxBool _controlsLocked = false.obs;

  Timer? _progressTimer;
  bool _isUploadingProgress = false;
  bool _pageActive = true;
  Duration? _lastPosition;

  // Toggle visibility for custom controls.
  bool _showControls = true;
  Timer? _hideTimer;

  // Settings for skip gestures.
  static const int _skipSeconds = 10;

  // The movie item.
  NewMovieModel item = NewMovieModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _extractMovieItem();

    // Keep screen on.
    WakelockPlus.enable();

    // Set immersive landscape mode.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _initializeVideo();
    _startProgressTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageActive = false;
    _progressTimer?.cancel();
    _hideTimer?.cancel();
    // Upload final progress.
    _uploadProgress(isFinal: true);
    _chewieController?.dispose();
    _controller?.dispose();

    // Reset system UI.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    WakelockPlus.disable();
    super.dispose();
  }

  // Listen for app lifecycle events.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        _pageActive = false;
        _lastPosition = _controller?.value.position;
        _controller?.pause();
        _progressTimer?.cancel();
        _uploadProgress(isFinal: true);
        WakelockPlus.disable();
        break;
      case AppLifecycleState.resumed:
        _pageActive = true;
        WakelockPlus.enable();
        if (_lastPosition != null) {
          _controller?.seekTo(_lastPosition!);
        }
        _startProgressTimer();
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        break;
      case AppLifecycleState.hidden:
        _pageActive = false;
        _controller?.pause();
        _progressTimer?.cancel();
        _uploadProgress(isFinal: true);
        WakelockPlus.disable();
        break;
    }
  }

  void _extractMovieItem() {
    dynamic movieData = widget.params['item'] ??
        widget.params['video_item'] ??
        widget.params['movie'] ??
        widget.params['video'];

    if (movieData is NewMovieModel) {
      item = movieData;
    } else if (movieData != null) {
      try {
        item = NewMovieModel.fromJson(Map<String, dynamic>.from(movieData));
      } catch (e) {
        Utils.toast("Error parsing movie data");
        _showError.value = true;
        _errorMessage.value = "Invalid video data provided.";
      }
    } else {
      _showError.value = true;
      _errorMessage.value = "No video data found.";
    }
  }

  // Initialize video player and Chewie controller.
  Future<void> _initializeVideo() async {
    _showLoading.value = true;
    _showError.value = false;
    _videoInitialized.value = false;

    final videoUrl = item.get_video_url();
    if (videoUrl.isEmpty || !(Uri.tryParse(videoUrl)?.isAbsolute ?? false)) {
      _errorMessage.value = "Invalid video URL.";
      _showError.value = true;
      _showLoading.value = false;
      return;
    }

    await _controller?.dispose();
    _controller = VideoPlayerController.network(videoUrl);

    try {
      await _controller!.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _controller!,
        autoPlay: true,
        looping: false,
        fullScreenByDefault: true,
        aspectRatio: _controller!.value.aspectRatio,
        allowMuting: true,
        allowPlaybackSpeedChanging: true,
        allowFullScreen: true,
        autoInitialize: true,
        zoomAndPan: true,
        placeholder: _buildThumbnailLoading(),
        errorBuilder: (context, errorMessage) => _buildErrorView(errorMessage),
        materialProgressColors: ChewieProgressColors(
          playedColor: CustomTheme.accent,
          handleColor: CustomTheme.accent.withOpacity(0.8),
          backgroundColor: Colors.grey.shade700.withOpacity(0.6),
          bufferedColor: Colors.white.withOpacity(0.3),
        ),
        showOptions: true,
      );
      _chewieController?.addListener(_handleFullscreenChange);
      _resumeProgress();
      setState(() {
        _videoInitialized.value = true;
        _showLoading.value = false;
      });
    } catch (error) {
      _errorMessage.value = "Could not load video. Please try again.";
      _showError.value = true;
      _showLoading.value = false;
      _videoInitialized.value = false;
    }

    _controller?.addListener(() {
      if (_controller!.value.isBuffering && mounted) setState(() {});
    });
  }

  // Manage full-screen changes.
  void _handleFullscreenChange() {
    if (_chewieController == null) return;
    if (_chewieController!.isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    }
  }

  // Resume from saved progress.
  void _resumeProgress() {
    int savedProgress = Utils.int_parse(item.watch_progress);
    if (savedProgress > 5 &&
        _controller != null &&
        _controller!.value.duration > Duration(seconds: savedProgress + 10)) {
      _controller!.seekTo(Duration(seconds: savedProgress - 2));
      _showToast("Resuming playback...");
    }
  }

  // Start a periodic timer to upload progress.
  void _startProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!_pageActive) {
        timer.cancel();
        return;
      }
      _uploadProgress();
    });
  }

  Future<void> _uploadProgress({bool isFinal = false}) async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _controller!.value.duration == Duration.zero) return;
    if (_isUploadingProgress && !isFinal) return;
    _isUploadingProgress = true;
    try {
      int progress = _controller!.value.position.inSeconds;
      int maxProgress = _controller!.value.duration.inSeconds;
      int lastSaved = Utils.int_parse(item.watch_progress);
      if (isFinal || (progress - lastSaved).abs() > 5) {
        item.watch_progress = progress.toString();
        item.max_progress = maxProgress.toString();
        item.watch_status = 'Active';
        item.watched_movie = 'Yes';
        await item.submitViewProgress(progress, maxProgress);
      }
    } catch (e) {
      print("Error uploading progress: $e");
    } finally {
      _isUploadingProgress = false;
    }
  }

  // Helper to show toast messages.
  void _showToast(String message) {
    Get.rawSnackbar(
      messageText: FxText.bodyMedium(message, color: Colors.white),
      backgroundColor: Colors.black.withOpacity(0.7),
      borderRadius: 8,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // --- Custom Controls with Gesture Detector ---
  Widget _buildCustomControls() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showControls = !_showControls;
        });
        _resetHideTimer();
      },
      onDoubleTapDown: (details) {
        final screenWidth = MediaQuery.of(context).size.width;
        if (details.globalPosition.dx < screenWidth / 2) {
          _skipBack();
        } else {
          _skipForward();
        }
        _resetHideTimer();
      },
      child: AnimatedOpacity(
        opacity: _showControls ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Stack(
          children: [
            // Top Bar with back and close
            // Positioned(top: 0, left: 0, right: 0, child: _buildTopBar()),
            // Center controls: rewind, play/pause, fast-forward
            Positioned.fill(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildControlButton(
                      icon: FeatherIcons.rewind,
                      tooltip: "Rewind $_skipSeconds s",
                      onPressed: _skipBack,
                      size: 50,
                    ),
                    _buildControlButton(
                      icon: _controller?.value.isPlaying ?? false
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      tooltip: _controller?.value.isPlaying ?? false
                          ? "Pause"
                          : "Play",
                      onPressed: _playPause,
                      size: 70,
                    ),
                    _buildControlButton(
                      icon: FeatherIcons.fastForward,
                      tooltip: "Forward $_skipSeconds s",
                      onPressed: _skipForward,
                      size: 50,
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Bar showing current time and options
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomBar(),
            ),
          ],
        ),
      ),
    );
  }

  void _resetHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 5), () {
      setState(() {
        _showControls = false;
      });
    });
  }

  // --- UI Components ---

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 50,
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(FeatherIcons.arrowLeft, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FxText.titleMedium(item.title, color: Colors.white),
          const SizedBox(height: 4),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        )
      ],
    );
  }

  Widget _buildBottomBar() {
    // Protect against null _controller.
    if (_controller == null || !_controller!.value.isInitialized) {
      return const SizedBox();
    }
    final currentTime = _formatDuration(_controller!.value.position);
    final totalTime = _formatDuration(_controller!.value.duration);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
          .copyWith(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          Text(
            "$currentTime / $totalTime",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const Spacer(),
          _buildOptionsButton(),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = duration.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return hours > 0 ? "$hours:$minutes:$seconds" : "$minutes:$seconds";
  }

  Widget _buildOptionsButton() {
    return _buildControlButton(
      icon: FeatherIcons.settings,
      tooltip: "Options",
      onPressed: () {
        // Optionally implement a custom popup for options.
      },
      size: 28,
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    double size = 28,
    Color? backgroundColor,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: backgroundColor ?? Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            onPressed();
            _resetHideTimer();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon, color: Colors.white.withOpacity(0.9), size: size),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailLoading() {
    return Container(
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (item.getThumbnail().isNotEmpty)
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: item.getThumbnail(),
                fit: BoxFit.contain,
                errorWidget: (context, url, error) => const SizedBox.shrink(),
              ),
            ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: CustomTheme.accent,
                strokeWidth: 3,
              ),
              const SizedBox(height: 20),
              FxText.bodyLarge("Loading Video...", color: Colors.white70),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(FeatherIcons.alertTriangle,
              color: Colors.redAccent, size: 50),
          const SizedBox(height: 15),
          FxText.titleMedium("Playback Error",
              color: Colors.white, fontWeight: 600),
          const SizedBox(height: 8),
          FxText(
            message,
            color: Colors.white70,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FxButton.outlined(
                onPressed: () => Get.back(),
                borderColor: Colors.white54,
                borderRadiusAll: 8,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: FxText("Go Back", color: Colors.white70),
              ),
              const SizedBox(width: 15),
              FxButton(
                onPressed: _initializeVideo,
                backgroundColor: CustomTheme.accent,
                borderRadiusAll: 8,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: FxText("Retry", color: Colors.black, fontWeight: 700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Control Actions ---
  void _playPause() {
    if (_controller == null) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _progressTimer?.cancel();
      } else {
        _controller!.play();
        _startProgressTimer();
      }
    });
  }

  void _skipBack() {
    if (_controller == null) return;
    final current = _controller!.value.position;
    final newPos = current - Duration(seconds: _skipSeconds);
    _controller!.seekTo(newPos < Duration.zero ? Duration.zero : newPos);
  }

  void _skipForward() {
    if (_controller == null) return;
    final current = _controller!.value.position;
    final duration = _controller!.value.duration;
    final newPos = current + Duration(seconds: _skipSeconds);
    _controller!.seekTo(newPos > duration ? duration : newPos);
  }

  @override
  Widget build(BuildContext context) {
    // Use Obx to reactively rebuild when observable variables change.
    return Obx(() => Scaffold(
          backgroundColor: Colors.black,
          appBar: _buildAppBar(),
          body: Stack(
            alignment: Alignment.center,
            children: [
              if (_videoInitialized.value && _chewieController != null)
                Chewie(controller: _chewieController!),
              if (_showLoading.value) _buildThumbnailLoading(),
              if (_showError.value) _buildErrorView(_errorMessage.value),
              _buildCustomControls(),
            ],
          ),
          floatingActionButton:
              (!_videoInitialized.value || _controller == null)
                  ? null
                  : FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          _controller!.value.isPlaying
                              ? _controller!.pause()
                              : _controller!.play();
                        });
                      },
                      child: Icon(_controller!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow),
                    ),
        ));
  }
}
