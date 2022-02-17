import 'package:flutter/material.dart';

import 'animanted_play_pause.dart';

class CenterPlayButton extends StatelessWidget {
  const CenterPlayButton({
    Key? key,
    required this.backgroundColor,
    this.iconColor,
    required this.show,
    required this.isPlaying,
    required this.isFinished,
    this.onPressed,
  }) : super(key: key);

  final Color backgroundColor;
  final Color? iconColor;
  final bool show;
  final bool isPlaying, isFinished;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: AnimatedOpacity(
          opacity: show ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(48.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                // Always set the iconSize on the IconButton, not on the Icon itself:
                // https://github.com/flutter/flutter/issues/52980
                child: IconButton(
                  iconSize: 72,
                  icon: isFinished
                      ? Icon(Icons.replay, color: iconColor)
                      : AnimatedPlayPause(
                          color: iconColor,
                          playing: isPlaying,
                        ),
                  onPressed: onPressed,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
