import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '/common/apipath.dart';
import '/common/global.dart';
import '/common/route_paths.dart';
import '/common/styles.dart';
import '/providers/app_config.dart';
import '/providers/payment_key_provider.dart';
import '/providers/user_profile_provider.dart';
import '/ui/screens/splash_screen.dart';
import '/ui/shared/appbar.dart';
import '/ui/shared/success_ticket.dart';
import 'package:paytm/paytm.dart';
import 'package:provider/provider.dart';

class PaytmPayment extends StatefulWidget {
  PaytmPayment(this.index, this.payAmount);
  final int index;
  final payAmount;
  @override
  _PaytmPaymentState createState() => _PaytmPaymentState();
}

class _PaytmPaymentState extends State<PaytmPayment> {
  String? payment_response;

  //Live
//  String mid = "NuhVFW74392760220848";
//  String PAYTM_MERCHANT_KEY = "_6NEbzbEXmzYqUWQ";
  String website = "DEFAULT";
  bool testing = false;
  bool isBack = true;
  bool isShowing = true;
  var paymentResponse, createdDate, createdTime;

  //Testing
  // String mid = "TEST_MID_HERE";
  // String PAYTM_MERCHANT_KEY = "TES_KEY_HERE";
  // String website = "WEBSTAGING";
  // bool testing = true;

  double? amount = 1;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isBack = true;
    });
  }

  Widget makeListTile1() {
    var planDetails = Provider.of<AppConfig>(context, listen: false).planList;
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 20.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: Icon(
          FontAwesomeIcons.sortAmountDownAlt,
          color: Colors.white,
          size: 20.0,
        ),
      ),
      title: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Text(
          '${planDetails[widget.index].name}',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.0),
        ),
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
                  child: Text(
                      'Min duration ' +
                          '${planDetails[widget.index].intervalCount}' +
                          ' days',
                      style: TextStyle(color: Colors.white, fontSize: 12.0)),
                ),
              ],
            ),
          ],
        ),
      ),
      trailing: Column(children: <Widget>[
        widget.payAmount == null
            ? Text("Amount: " +
                '\n' +
                '${planDetails[widget.index].amount} ' +
                '${planDetails[widget.index].currency}')
            : Text("Amount: " +
                '\n' +
                '${widget.payAmount} ' +
                '${planDetails[widget.index].currency}'),
      ]),
    );
  }

  Widget razorLogoContainer() {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(10.0)),
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(50.0),
            child: Image.asset(
              "assets/paytmlogo.png",
              scale: 1.0,
              width: 150.0,
            ),
          )
        ],
      ),
    );
  }

  Widget paymentDetailsCard() {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(10.0)),
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: ClampingScrollPhysics(),
          children: <Widget>[makeListTile1()],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var payment =
        Provider.of<PaymentKeyProvider>(context, listen: false).paymentKeyModel;
    var planDetails = Provider.of<AppConfig>(context, listen: false).planList;
    var userDetails = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileModel;
    amount = widget.payAmount == null
        ? double.tryParse("${planDetails[widget.index].amount}")
        : double.tryParse("${widget.payAmount}");
    return Scaffold(
      appBar: customAppBar(context, "Paytm Payment") as PreferredSizeWidget?,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 20.0,
              ),
              Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin:
                    new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: razorLogoContainer(),
              ),
              SizedBox(
                height: 30.0,
              ),
              paymentDetailsCard(),
              SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: () {
                  if (planDetails[widget.index].currency != "INR") {
                    Fluttertoast.showToast(
                        msg: "Paytm supports only INR currency");
                    return;
                  } else {
                    generateTxnToken(0, payment!.paytmkey, payment.paytmpass,
                        userDetails!.user!.id);
                  }
                },
                color: primaryBlue,
                child: Text(
                  "Pay using Wallet",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: () {
                  if (planDetails[widget.index].currency != "INR") {
                    Fluttertoast.showToast(
                        msg: "Paytm supports only INR currency");
                    return;
                  } else {
                    generateTxnToken(1, payment!.paytmkey, payment.paytmpass,
                        userDetails!.user!.id);
                  }
                },
                color: primaryBlue,
                child: Text(
                  "Pay using Net Banking",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: () {
                  if (planDetails[widget.index].currency != "INR") {
                    Fluttertoast.showToast(
                        msg: "Paytm supports only INR currency");
                    return;
                  } else {
                    generateTxnToken(2, payment!.paytmkey, payment.paytmpass,
                        userDetails!.user!.id);
                  }
                },
                color: primaryBlue,
                child: Text(
                  "Pay using UPI",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: () {
                  if (planDetails[widget.index].currency != "INR") {
                    Fluttertoast.showToast(
                        msg: "Paytm supports only INR currency");
                    return;
                  } else {
//                    Fluttertoast.showToast(msg: "Paytm supports only INR currency");
                    generateTxnToken(3, payment!.paytmkey, payment.paytmpass,
                        userDetails!.user!.id);
                  }
                },
                color: primaryBlue,
                child: Text(
                  "Pay using Credit Card",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  goToDialog2() {
    if (isShowing == true) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => WillPopScope(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                backgroundColor: Colors.white,
                title: Text(
                  "Saving Payment Info",
                  style: TextStyle(color: Color(0xFF3F4654)),
                ),
                content: Container(
                  height: 70.0,
                  width: 150.0,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              onWillPop: () async => isBack));
    } else {
      Navigator.pop(context);
    }
  }

  void generateTxnToken(int mode, mid, mKey, uid) async {
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();
    String callBackUrl = (testing
            ? 'https://securegw-stage.paytm.in'
            : 'https://securegw.paytm.in') +
        '/theia/paytmCallback?ORDER_ID=' +
        orderId;

    var url = 'https://desolate-anchorage-29312.herokuapp.com/generateTxnToken';

    var body = json.encode({
      "mid": mid,
      "key_secret": mKey,
      "website": website,
      "orderId": orderId,
      "amount": amount.toString(),
      "callbackUrl": callBackUrl,
      "custId": "$uid",
      "mode": mode.toString(),
      "testing": testing ? 0 : 1
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        body: body,
        headers: {'Content-type': "application/json"},
      );
      String txnToken = response.body;
      setState(() {
        payment_response = txnToken;
      });

      var paytmResponse = Paytm.payWithPaytm(
          mid, orderId, txnToken, amount.toString(), callBackUrl, testing);

      paytmResponse.then((value) {
        setState(() {
          loading = false;
          payment_response = value.toString();
          if ("$value" == '') {
            return;
          } else {
            if (value['response']['STATUS'] == "TXN_SUCCESS") {
              setState(() {
                isShowing = true;
              });
              sendPaymentDetails(value['response']['TXNID']);
            } else if (value['response']['STATUS'] == "TXN_PENDING") {
              sendPaymentDetails(value['response']['TXNID']);
            }
          }
        });
      });
    } catch (e) {
      print('sfmms2');
      print(e);
    }
  }

  goToDialog(subdate, time, msgResponse, amount) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => new GestureDetector(
              child: Container(
                color: Colors.white.withOpacity(0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SuccessTicket(
                      msgResponse: "Your transaction successful",
                      subDate: subdate,
                      time: time,
                      planAmount: amount,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, RoutePaths.splashScreen,
                            arguments: SplashScreen(
                              token: authToken,
                            ));
                      },
                    )
                  ],
                ),
              ),
            ));
  }

  sendPaymentDetails(transactionId) async {
    var planDetails = Provider.of<AppConfig>(context, listen: false).planList;
    try {
      final sendResponse =
          await http.post(Uri.parse(APIData.sendRazorDetails), body: {
        "reference": "$transactionId",
        "amount": "${planDetails[widget.index].amount}",
        "plan_id": "${planDetails[widget.index].id}",
        "status": "1",
        "method": "Paytm",
      }, headers: {
        HttpHeaders.authorizationHeader: "Bearer $authToken",
        "Accept": "application/json"
      });
      var response = json.decode(sendResponse.body);
      debugPrint("resCode: ${sendResponse.statusCode}");
      if (sendResponse.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Your transaction has been successfully completed.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
//                      timeInSecForIos: 3,
            backgroundColor: primaryBlue,
            textColor: Colors.white,
            webPosition: "center");
        var msgResponse = response['message'];
        var subRes = response['subscription'];
        var date = subRes['created_at'];
        var time = subRes['created_at'];
        createdDate = DateFormat('d MMM y').format(DateTime.parse(date));
        createdTime = DateFormat('HH:mm a').format(DateTime.parse(time));
        setState(() {
          isShowing = false;
        });
        goToDialog(createdDate, createdTime, msgResponse,
            planDetails[widget.index].amount);
      } else {
        setState(() {
          isShowing = false;
        });
        Fluttertoast.showToast(
            msg: "Your transaction has been failed",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
//                      timeInSecForIos: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            webPosition: "center");
      }
    } catch (error) {
      print(error);
    }
  }
}
