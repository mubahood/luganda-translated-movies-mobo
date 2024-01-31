import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:omulimisa2/utils/CustomTheme.dart';
import 'package:video_player/video_player.dart';

import '../../models/MovieModel.dart';

/// Stateful widget to fetch and then display video content.
class VideoPlayerScreenOld extends StatefulWidget {
  MovieModel item;

  VideoPlayerScreenOld(this.item, {super.key});

  @override
  _VideoPlayerScreenStateOld createState() => _VideoPlayerScreenStateOld();
}

class _VideoPlayerScreenStateOld extends State<VideoPlayerScreenOld> {
  late VideoPlayerController _controller;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    widget.item.get_video_url();
    print(widget.item.video_url);
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.item.video_url))
          ..initialize().then((_) {
            if (_controller.value.isInitialized) {
              try {
                isLoading = false;
                _controller.play();
                setState(() {});
              } catch (e) {
                isLoading = false;
                setState(() {});
                print(e);
              }
            }
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
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
      ),
      backgroundColor: Colors.black,
      body: RotatedBox(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    _controller.dispose();
  }
}
