import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/common/apipath.dart';
import '/common/global.dart';
import '/common/route_paths.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '/models/login_model.dart';
import '/models/user_profile_model.dart';

class UserProfileProvider with ChangeNotifier {
  UserProfileModel? userProfileModel;
  LoginModel? loginModel;

  Future<UserProfileModel?> getUserProfile(BuildContext context) async {
    try {
      final response =
          await http.get(Uri.parse(APIData.userProfileApi), headers: {
        // "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        HttpHeaders.authorizationHeader: "Bearer $authToken",
      });
      print("userprofile: ${response.statusCode}");
      print("userprofile: ${response.body}");
      if (response.statusCode == 200) {
        userProfileModel =
            UserProfileModel.fromJson(json.decode(response.body));
      } else {
        await storage.deleteAll();
        print("user_profile_provider: else part");
        Navigator.pushNamed(context, RoutePaths.loginHome);
        throw "Can't get user profile";
      }
    } catch (error) {
      await storage.deleteAll();
      print("user_profile_provider: $error");
      return Navigator.pushNamed(context, RoutePaths.loginHome);
      // return null;
    }
    notifyListeners();
    // return userProfileModel;
  }
}
