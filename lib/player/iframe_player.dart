import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/common/global.dart';
import 'package:wakelock/wakelock.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IFramePlayerPage extends StatefulWidget {
  IFramePlayerPage({
    this.url,
  });
  final String? url;

  @override
  _IFramePlayerPageState createState() => _IFramePlayerPageState();
}

class _IFramePlayerPageState extends State<IFramePlayerPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  var playerResponse;
  GlobalKey sc = new GlobalKey<ScaffoldState>();

  void stopScreenLock() async {
    Wakelock.enable();
  }

  @override
  void initState() {
    super.initState();
    stopScreenLock();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    Wakelock.disable();
    super.dispose();
  }

  //  Handle back press
  Future<bool> onWillPopS() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Navigator.pop(context);
      return Future.value(true);
    }
    return Future.value(true);
  }

  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        print("1000");
        break;
      case AppLifecycleState.paused:
        print("1001");
//        Navigator.pop(context);
        break;
      case AppLifecycleState.resumed:
        print("1003");
//        Navigator.pop(context);
        break;
      case AppLifecycleState.detached:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    double width;
    double height;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
      return JavascriptChannel(
          name: 'Toaster',
          onMessageReceived: (JavascriptMessage message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message.message)),
            );
          });
    }

    return WillPopScope(
      child: Scaffold(
        key: sc,
        body: Container(
            width: width,
            height: height,
            child: WebView(
                initialUrl: Uri.dataFromString('''
                    <html>
                    <body style="width:100%;height:100%;display:block;background:black;">
                    <iframe width="100%" height="100%" 
                    style="width:100%;height:100%;display:block;background:black;"
                    src="${widget.url}" 
                    frameborder="0" 
                    allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" 
                     allowfullscreen="allowfullscreen"
                      mozallowfullscreen="mozallowfullscreen" 
                      msallowfullscreen="msallowfullscreen" 
                      oallowfullscreen="oallowfullscreen" 
                      webkitallowfullscreen="webkitallowfullscreen"
                     >
                    </iframe>
                    </body>
                    </html>
                  ''',
                        mimeType: 'text/html',
                        encoding: Encoding.getByName('utf-8'))
                    .toString(),
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                javascriptChannels: <JavascriptChannel>[
                  _toasterJavascriptChannel(context),
                ].toSet())),
      ),
      onWillPop: onWillPopS,
    );
  }
}
