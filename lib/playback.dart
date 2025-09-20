import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomPlaybackBar extends StatefulWidget {
  final VideoPlayerController player;

  const CustomPlaybackBar({super.key, required this.player});

  @override
  State<CustomPlaybackBar> createState() => _CustomPlaybackBarState();
}

class _CustomPlaybackBarState extends State<CustomPlaybackBar> {
  late Duration _currentPosition;
  late Duration _totalDuration;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.player.value.position;
    _totalDuration = widget.player.value.duration;
    _isPlaying = widget.player.value.isPlaying;

    widget.player.addListener(_videoListener);
  }

  void _videoListener() {
    if (mounted) {
      setState(() {
        _currentPosition = widget.player.value.position;
        _totalDuration = widget.player.value.duration;
        _isPlaying = widget.player.value.isPlaying;
      });
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        widget.player.pause();
      } else {
        widget.player.play();
      }
    });
  }

  void _seekTo(Duration position) {
    widget.player.seekTo(position);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final bool isInitialized = widget.player.value.isInitialized;
    final double maxValue = _totalDuration.inMilliseconds.toDouble();
    final double currentValue = _currentPosition.inMilliseconds.toDouble();

    final double sliderValue = maxValue > 0
        ? currentValue.clamp(0.0, maxValue)
        : 0.0;

    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          IconButton(
            onPressed: isInitialized ? _togglePlayPause : null,
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: isInitialized ? Colors.white : Colors.grey,
            ),
          ),
          Text(
            _formatDuration(_currentPosition),
            style: const TextStyle(color: Colors.white),
          ),
          Expanded(
            child: Slider(
              value: sliderValue,
              min: 0.0,
              max: maxValue > 0 ? maxValue : 1.0,
              onChanged: isInitialized && maxValue > 0
                  ? (value) {
                      _seekTo(Duration(milliseconds: value.toInt()));
                    }
                  : null,
              activeColor: Colors.white,
              inactiveColor: Colors.white.withOpacity(0.3),
            ),
          ),
          Text(
            _formatDuration(_totalDuration),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.player.removeListener(_videoListener);
    super.dispose();
  }
}
