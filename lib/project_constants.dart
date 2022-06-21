import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Purple lightPurple #821591
//Purple darkPurple #540E79
//fontName Anton
//fontName Roboto

bool isUserLogout = true;

int maxLines = 3;

Color neuColor = const Color(0xFFecf0f3);
Color darkPink = Colors.pink;
Color lightPink = Colors.pinkAccent;
Color lightPurple = const Color(0xff821591);
Color darkPurple = const Color(0xff540E79);
Color whiteColor = Colors.white;
Color blackColor = Colors.black;
Color defaultUIColor = const Color(0xff540E79);

final personNameController = TextEditingController();

final currentUserId = FirebaseAuth.instance.currentUser!.uid;
final currentUserEmail = FirebaseAuth.instance.currentUser!.email;

DateTime currentDateTime = DateTime.now();

String formatTime() {
  String time;

  if (currentDateTime.hour > 12) {
    int hr = currentDateTime.hour - 12;
    int min = currentDateTime.minute;
    time = hr.toString() + ' : ' + min.toString() + ' PM';
    return time;
  } else {
    int hr = currentDateTime.hour;
    int min = currentDateTime.minute;
    time = hr.toString() + ' : ' + min.toString() + ' AM';
    return time;
  }
}

String mapLocation = 'Get Map Location';

final storage = const FlutterSecureStorage();

saveMode(bool modeValue) async {
  await storage.write(key: 'mode', value: modeValue.toString());
  print('-----------------------------------');
  print('modeValue : $modeValue is saved');
}

readMode() async {
  String? modeValue = await storage.read(key: 'mode') ?? 'false';
  print('Mode is reading.......');
  if (modeValue == 'true') {
    print('Mode Value is true');
    return true;
  }
  if (modeValue == 'false') {
    print('Mode Value is true');
    return false;
  }
}

saveUserRecommendations(String recommendedValue) async {
  await storage.write(key: 'recommendation', value: recommendedValue);
  print('-----------------------------------');
  print('Recommendation : $recommendedValue is saved');
}

readUserRecommendations() async {
  String? recommendedValue =
      await storage.read(key: 'recommendation') ?? 'Food & Beverages';
  print('User Recommendations is reading.......');
  print('recommendedValue is $recommendedValue');
  return recommendedValue;
}

generateUniqueId() async {
  print('unique Id is reading.....');
  String? stringId = await storage.read(key: 'id') ?? '1';
  print('$stringId Id is Read');
  int integerId = int.parse(stringId);
  integerId++;
  String uniqueId = integerId.toString();
  await storage.write(key: 'id', value: uniqueId);
  print('$uniqueId Id is Saved');
  print('----------------------');
  return uniqueId;
}

saveUsers(double value) async {
  await storage.write(key: 'saveUsers', value: value.toString());
  print('-----------------------------------');
  print('Users : $value is saved');
}

saveRequests(double value) async {
  await storage.write(key: 'saveRequests', value: value.toString());
  print('-----------------------------------');
  print('Requests : $value is saved');
}

saveReports(double value) async {
  await storage.write(key: 'saveReports', value: value.toString());
  print('-----------------------------------');
  print('Reports : $value is saved');
}

readUsers() async {
  String? value = await storage.read(key: 'saveUsers') ?? '25';
  print('User Value is reading.......');
//  int intValue = int.parse(value);
//  double _total = intValue.toDouble();
  return value;
}

readRequests() async {
  String? value = await storage.read(key: 'saveRequests') ?? '50';
  print('Requests Value is reading.......');
//  int intValue = int.parse(value);
//  double _total = intValue.toDouble();
  return value;
}

readReports() async {
  String? value = await storage.read(key: 'saveReports') ?? '25';
  print('Reports Value is reading.......');
//  int intValue = int.parse(value);
//  double _total = intValue.toDouble();
  return value;
}

saveAdminLogin(bool value) async {
  await storage.write(key: 'saveAdminLogin', value: value.toString());
  print('-----------------------------------');
  print('Admin Login : $value is saved');
}

readAdminLogin() async {
  String? value = await storage.read(key: 'saveAdminLogin') ?? 'false';
  print('Admin Login is reading.......');
  if (value == 'true') {
    print('Admin Login Value is true');
    return true;
  }
  if (value == 'false') {
    print('Admin Login Value is true');
    return false;
  }
}
