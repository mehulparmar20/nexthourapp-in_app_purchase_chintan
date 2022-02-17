import '/custom_player/src/chewie_player.dart';
import '/custom_player/src/material_controls.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:vector_math/vector_math_64.dart';

class PlayerWithControls extends StatefulWidget {
  PlayerWithControls({Key? key, this.title, this.downloadStatus})
      : super(key: key);
  final title;
  final downloadStatus;

  @override
  State<StatefulWidget> createState() {
    return _PlayerWithControlsState();
  }
}

class _PlayerWithControlsState extends State<PlayerWithControls>
    with SingleTickerProviderStateMixin {
  late Animation _animation;
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();

    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 200));
    _animation = Tween(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    final ChewieController chewieController = ChewieController.of(context);

    double _calculateAspectRatio(BuildContext context) {
      final size = MediaQuery.of(context).size;
      final width = size.width;
      final height = size.height;

      return width > height ? width / height : height / width;
    }

    Widget _buildControls(
      BuildContext context,
      ChewieController chewieController,
    ) {
      final controls = Theme.of(context).platform == TargetPlatform.android
          ? MaterialControls(
              title: widget.title,
              downloadStatus: widget.downloadStatus,
            )
          : MaterialControls(
              title: widget.title,
              downloadStatus: widget.downloadStatus,
            );
      return chewieController.showControls
          ? chewieController.customControls ?? controls
          : Container();
    }

    GestureDetector _buildPlayerWithControls(
        ChewieController chewieController, BuildContext context) {
      return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onDoubleTap: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
          },
          child: Stack(
            children: <Widget>[
              chewieController.placeholder ?? Container(),
              Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.diagonal3(Vector3(
                    _animation.value, _animation.value, _animation.value)),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: chewieController.aspectRatio ??
                        chewieController
                            .videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(chewieController.videoPlayerController),
                  ),
                ),
              ),
              chewieController.overlay ?? Container(),
              if (!chewieController.isFullScreen)
                _buildControls(context, chewieController)
              else
                SafeArea(
                  child: _buildControls(context, chewieController),
                ),
            ],
          ));
    }

    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: AspectRatio(
          aspectRatio: _calculateAspectRatio(context),
          child: _buildPlayerWithControls(chewieController, context),
        ),
      ),
    );
  }
}
