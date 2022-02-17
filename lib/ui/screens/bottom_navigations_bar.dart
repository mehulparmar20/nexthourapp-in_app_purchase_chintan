import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:native_admob_flutter/native_admob_flutter.dart';
import '/common/global.dart';
import 'Downloaded_videos.dart';
import 'menu_screen.dart';
import 'search_screen.dart';
import 'wishlist_screen.dart';
import 'home_screen.dart';

class MyBottomNavigationBar extends StatefulWidget {
  MyBottomNavigationBar({this.pageInd});
  final pageInd;

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int? _selectedIndex;
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    SearchScreen(),
    WishListScreen(),
    DownloadedVideos(),
    MenuScreen(),
  ];

  // Timer? _timerForInter;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pageInd != null ? widget.pageInd : 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          backgroundColor: Theme.of(context).primaryColorDark,
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).primaryColorLight,
            selectedIconTheme: Theme.of(context).primaryIconTheme,
            unselectedIconTheme: Theme.of(context).iconTheme,
            selectedItemColor: Theme.of(context).textSelectionColor,
            unselectedItemColor: Theme.of(context).hintColor,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
              BottomNavigationBarItem(
                  label: "Search", icon: Icon(Icons.search)),
              BottomNavigationBarItem(
                  label: "Wishlist", icon: Icon(Icons.favorite_border)),
              BottomNavigationBarItem(
                  label: "Download", icon: Icon(Icons.file_download)),
              BottomNavigationBarItem(label: 'Menu', icon: Icon(Icons.menu)),
            ],
            currentIndex: _selectedIndex!,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
            onTap: _onItemTapped,
          ),
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex!),
          )),
      onWillPop: onWillPopS,
    );
  }
}

// Handle back press to exit
Future<bool> onWillPopS() {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
    currentBackPressTime = now;
    Fluttertoast.showToast(msg: "Press again to exit.");
    return Future.value(false);
  }

  if (Platform.isAndroid) {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  } else if (Platform.isIOS) {
    return exit(0);
  }
  return exit(0);
}
