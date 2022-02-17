import 'package:flutter/material.dart';
import '/providers/app_config.dart';
import '/ui/shared/appbar.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DonationScreen extends StatefulWidget {
  @override
  _DonationScreenState createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  @override
  Widget build(BuildContext context) {
    var donationURL =
        Provider.of<AppConfig>(context).appModel!.config!.donationLink;
    return Scaffold(
        appBar: customAppBar(context, "Donate") as PreferredSizeWidget?,
        body: donationURL == null
            ? Center(
                child: Text("Donation link not available"),
              )
            : Container(
                child: WebView(
                  initialUrl: '$donationURL',
                  javascriptMode: JavascriptMode.unrestricted,
                ),
              ));
  }
}
