import 'dart:async';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player_app/playback.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String title;
  final String videoPath;
  const VideoPlayerScreen({
    super.key,
    this.title = "",
    required this.videoPath,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  double _lookAroundOffset = 0.0;
  double _verticalLookOffset = 0.0;

  late VideoPlayerController _controller;
  ChewieController? chewieController;

  bool showLeftSide = true;
  bool _areControlsVisible = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
    // _listenToGyroscope();
    // _startUpdateTimer();
  }

  void _initializeVideoPlayer() async {
    _controller = VideoPlayerController.file(File(widget.videoPath));

    await _controller.initialize();

    chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      looping: true,
      showControls: false,
    );

    if (mounted) {
      await Future.delayed(Duration(milliseconds: 100));
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  void _toggleControlsVisibility() {
    setState(() {
      _areControlsVisible = !_areControlsVisible;
    });
  }

  void _resetLookPosition() {
    setState(() {
      _lookAroundOffset = 0.0;
      _verticalLookOffset = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTap: _toggleControlsVisibility,
        onDoubleTap: _resetLookPosition,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                minScale: 1.0,
                maxScale: 20.0,
                child: ClipRect(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double parentWidth = constraints.maxWidth;

                      const double scaleFactor = 2.0;

                      final double baseOffset = showLeftSide
                          ? (parentWidth * scaleFactor) / 4.0
                          : -(parentWidth * scaleFactor) / 4.0;

                      final double totalHorizontalOffset =
                          baseOffset + _lookAroundOffset;

                      return Transform.translate(
                        offset: Offset(
                          totalHorizontalOffset,
                          _verticalLookOffset,
                        ),
                        child: Transform.scale(
                          scale: scaleFactor,
                          alignment: Alignment.center,
                          child:
                              !_controller.value.isBuffering &&
                                  chewieController != null
                              ? Center(
                                  child: AspectRatio(
                                    aspectRatio: _controller.value.aspectRatio,
                                    child: Chewie(
                                      controller: chewieController!,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: CircularProgressIndicator(),
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SafeArea(
                child: Row(
                  children: [
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.withValues(alpha: 0.5),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Spacer(),
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.withValues(alpha: 0.5),
                      ),
                      onPressed: () {
                        showLeftSide = !showLeftSide;
                        setState(() {});
                      },
                      icon: Icon(Icons.swap_horiz, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: _areControlsVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: AbsorbPointer(
                  absorbing: !_areControlsVisible,
                  child: CustomPlaybackBar(player: _controller),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
