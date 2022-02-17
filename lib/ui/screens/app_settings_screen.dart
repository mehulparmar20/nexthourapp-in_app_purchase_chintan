import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/common/global.dart';
import '/ui/shared/appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsScreen extends StatefulWidget {
  @override
  _AppSettingsScreenState createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  late Connectivity connectivity;
  // ignore: cancel_subscriptions
  StreamSubscription<ConnectivityResult>? subscription;
  var _connectionStatus = 'Unknown';

  void _onChanged1(bool value) {
    setState(() {
      boolValue = value;
      addBoolToSF(value);
      print(value);
    });
  }

  Widget wifiTitleText() {
    return Text(
      "Wi-Fi Only",
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.0),
    );
  }

  Widget leadingWifiListTile() {
    return Container(
      padding: EdgeInsets.only(right: 20.0),
      decoration: BoxDecoration(
          border:
              Border(right: new BorderSide(width: 1.0, color: Colors.white24))),
      child: Icon(
        FontAwesomeIcons.signal,
        color: Colors.white,
        size: 20.0,
      ),
    );
  }

  Widget wifiSubtitle() {
    return Container(
      height: 40.0,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 8.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text("Play video only when connected to wi-fi.",
                    style: TextStyle(color: Colors.white, fontSize: 12.0)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget wifiSwitch() {
    return Switch(
        activeColor: Theme.of(context).primaryColor,
        inactiveThumbColor: Theme.of(context).primaryColor.withOpacity(0.1),
        inactiveTrackColor: Theme.of(context).primaryColorDark,
        value: boolValue!,
        onChanged: _onChanged1);
  }

//    Widget used to create ListTile to show wi-fi status
  Widget makeListTile1() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      tileColor: Theme.of(context).primaryColor.withOpacity(0.1),
      leading: leadingWifiListTile(),
      title: wifiTitleText(),
      subtitle: wifiSubtitle(),
      trailing: wifiSwitch(),
    );
  }

  Widget _listTile4() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 20.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: Icon(
          FontAwesomeIcons.mobile,
          color: Colors.white,
          size: 20.0,
        ),
      ),
      title: Text(
        "About Phone",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.0),
      ),
      subtitle: Container(
        height: 40.0,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 8.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text("Phone info, version, build number",
                      style: TextStyle(color: Colors.white, fontSize: 12.0)),
                ),
              ],
            ),
          ],
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 15.0,
        color: Color.fromRGBO(237, 237, 237, 1.0),
      ),
      onTap: () {
//        var route = MaterialPageRoute(
//            builder: (context) => AboutPhone());
//        Navigator.push(context, route);
      },
    );
  }

  Widget scaffold() {
    return Scaffold(
//      backgroundColor: Theme.of(context).backgroundColor,
        backgroundColor: Theme.of(context).primaryColorDark,
        appBar: customAppBar(context, "App Settings") as PreferredSizeWidget?,
        body: Container(
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                // Card(
                //   color: Theme.of(context).primaryColor.withOpacity(0.06),
                //   elevation: 4.0,
                //   shadowColor: Theme.of(context).primaryColorLight,
                //   child: makeListTile1(),
                // ),
                makeListTile1(),
                // Container(
                //   color: Theme.of(context).primaryColorDark,
                //   height: 15.0,
                // ),
                // SizedBox(
                //   height: 15.0,
                // ),
                // Card(
                //   color: Theme.of(context).primaryColor.withOpacity(0.06),
                //   elevation: 4.0,
                //   shadowColor: Theme.of(context).primaryColorLight,
                //   child: _listTile4(),
                // ),
              ],
            ))
        // Container(
        //     child:
        //     Card(
        //   elevation: 8.0,
        //   margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        //   child: ,
        // )
        // )
        );
  }

//  Used to save value to shared preference of wi-fi switch
  addBoolToSF(value) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('boolValue', value);
  }

//  Used to get saved value from shared preference of wi-fi switch
  getValuesSF() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      boolValue = prefs.getBool('boolValue');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getValuesSF();

//    Used to check connection status of use device
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result.toString();

      checkConnectionStatus = result.toString();
      if (result == ConnectivityResult.wifi) {
        setState(() {
          _connectionStatus = 'Wi-Fi';
        });
      } else if (result == ConnectivityResult.mobile) {
        setState(() {
          _connectionStatus = 'Mobile';
        });
      } else if (result == ConnectivityResult.none) {
//        var router = new MaterialPageRoute(
//            builder: (BuildContext context) => new NoNetwork());
//        Navigator.of(context).push(router);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (boolValue == null) {
      boolValue = false;
    }
    return scaffold();
  }
}
