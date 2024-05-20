import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/utils/CustomTheme.dart';
import 'package:omulimisa2/utils/Utilities.dart';
import 'package:video_player/video_player.dart';

import '../../models/MovieModel.dart';

/// Stateful widget to fetch and then display video content.
class VideoPlayerScreen extends StatefulWidget {
  MovieModel item;

  VideoPlayerScreen(this.item, {super.key});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  bool isLoading = true;
  ChewieController? chewieController = null;
  Chewie? playerWidget;

  bool progressUploaderInitiated = false;

  initProgressUploader() {
    if (progressUploaderInitiated) {
      return;
    }
    progressUploaderInitiated = true;
    progressUploader();
  }

  progressUploader() async {
    if (!pageIsActive) {
      return;
    }
    progressUploaderInitiated = true;
    int progress = 0;
    int max_progress = 0;
    try {
      progress = _controller.value.position.inSeconds;
      max_progress = _controller.value.duration.inSeconds;
    } catch (e) {
      print(e.toString());
    }

    if (progress > 0) {
      widget.item.watch_progress = progress.toString();
      widget.item.max_progress =
          _controller.value.duration.inSeconds.toString();
      widget.item.watch_status = 'Active';
      widget.item.watched_movie = 'Yes';
      await widget.item.save();
      await widget.item.submitViewProgress(progress, max_progress);
    }
    await Future.delayed(const Duration(seconds: 5));
    //progressUploader
    progressUploader();
  }

  bool pageIsActive = true;

  //dispose
  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    pageIsActive = false;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    _controller.dispose();
  }

  bool resumed = false;

  @override
  void initState() {
    super.initState();
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    initProgressUploader();

    widget.item.get_video_url();
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.item.video_url))
          ..initialize().then((_) {
            if (_controller.value.isInitialized) {
              try {
                isLoading = false;
                _controller.play();

                chewieController = ChewieController(
                  videoPlayerController: _controller,
                  autoPlay: false,
                  looping: true,
                  fullScreenByDefault: true,
                  aspectRatio: _controller.value.aspectRatio,
                  allowMuting: true,
                  allowPlaybackSpeedChanging: true,
                  allowFullScreen: true,
                  autoInitialize: true,
                  zoomAndPan: true,
                  overlay: const SizedBox.shrink(),
                  materialProgressColors: ChewieProgressColors(
                    playedColor: CustomTheme.accent,
                    handleColor: CustomTheme.accent,
                    backgroundColor: Colors.grey,
                    bufferedColor: CustomTheme.primary,
                  ),
                );
                playerWidget = Chewie(
                  controller: chewieController!,
                );

                playerWidget?.controller.addListener(() {
                  if (playerWidget!.controller.isFullScreen) {
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                        overlays: []);
                  } else {
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                        overlays: SystemUiOverlay.values);
                  }
                });

                setState(() {});

                if (!resumed) {
                  resumed = true;
                  /*SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeLeft,
                  ]);*/
                  //skip to progress
                  if (Utils.int_parse(widget.item.watch_progress) > 3) {
                    try {
                      _controller.seekTo(Duration(
                          seconds:
                              Utils.int_parse(widget.item.watch_progress)));
                      Utils.toast("Resuming...");
                    } catch (e) {
                      print(e.toString());
                    }
                  }
                }

                setState(() {});
              } catch (e) {
            isLoading = false;
          }
        }
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.addListener(() {
      if (!_controller.value.isPlaying) {
        setState(() {
          isLoading = false;
        });
      }

      //check if is loading
      if (_controller.value.isBuffering) {
        setState(() {
          isLoading = true;
        });
      }
      //done loading
      if (!_controller.value.isBuffering) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        title: Column(
          children: [
            Text(widget.item.title,
                style: const TextStyle(color: Colors.white)),
            FxText.bodySmall(
              "=> ${widget.item.video_url}",
              muted: true,
              color: Colors.white,
            )
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              //ENTER FULL
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: true
          ? playerWidget == null || isLoading
              ? Center(
                  child: Column(
                  children: [
                    SizedBox(
                      height: Get.height / 2.2,
                    ),
                    FxText(
                      "Loading...",
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        backgroundColor: Colors.black,
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(CustomTheme.accent),
                      ),
                    ),
                  ],
                ))
              : playerWidget
          : RotatedBox(
              quarterTurns: 1,
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          VideoPlayer(_controller),
                          SizedBox(
                            height: 20,
                            child: VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  colors: const VideoProgressColors(
                    playedColor: Colors.red,
                    bufferedColor: CustomTheme.primary,
                    backgroundColor: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        )
            : Container(
          child: isLoading
              ? const CircularProgressIndicator(
            color: Colors.white,
          )
              : const Text('Error loading video'),
        ),
      ),
      floatingActionButton:
          //plau=ing, hide
          _controller.value.isPlaying
              ? SizedBox.shrink()
              : FloatingActionButton(
                  onPressed: () {
                    Utils.toast("Please wait...");
                    widget.item.get_video_url();
                    setState(() {
                      isLoading = true;
                    });
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  child: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                ),
    );
  }
}
