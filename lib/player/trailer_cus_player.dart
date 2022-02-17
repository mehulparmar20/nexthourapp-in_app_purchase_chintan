import 'dart:io';
import 'package:flutter/material.dart';
import '/common/global.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import '../custom_player/src/chewie_player.dart';
import '../custom_player/src/chewie_progress_colors.dart';

class TrailerCustomPlayer extends StatefulWidget {
  TrailerCustomPlayer({this.title, this.url, this.downloadStatus});

  final String? title;
  final String? url;
  final int? downloadStatus;

  @override
  State<StatefulWidget> createState() {
    return _TrailerCustomPlayerState();
  }
}

class _TrailerCustomPlayerState extends State<TrailerCustomPlayer>
    with WidgetsBindingObserver {
  TargetPlatform? platform;
  late VideoPlayerController _videoPlayerController1;
  late VideoPlayerController _videoPlayerController2;
  late ChewieController _chewieController;
  DateTime? currentBackPressTime;

  void stopScreenLock() async {
    Wakelock.enable();
  }

  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        _chewieController.pause();
        debugPrint("Inactive");
        break;
      case AppLifecycleState.resumed:
        _chewieController.pause();
        break;
      case AppLifecycleState.paused:
        _chewieController.pause();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    this.stopScreenLock();
    setState(() {
      playerTitle = widget.title;
    });
    WidgetsBinding.instance!.addObserver(this);
    print(widget.url);
    _videoPlayerController1 = VideoPlayerController.network(widget.url!);
    _videoPlayerController2 = VideoPlayerController.network(widget.url!);

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.red,
        backgroundColor: Colors.white.withOpacity(0.6),
        bufferedColor: Colors.white,
      ),
      placeholder: Container(
        color: Colors.black,
      ),
      // autoInitialize: true,
    );

//    var r = _videoPlayerController1.value.aspectRatio;
    String os = Platform.operatingSystem;

    if (os == 'android') {
      setState(() {
        platform = TargetPlatform.android;
      });
    } else {
      setState(() {
        platform = TargetPlatform.iOS;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Chewie(
                controller: _chewieController,
                title: widget.title,
                downloadStatus: widget.downloadStatus,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
