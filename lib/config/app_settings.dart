import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppSettings extends ChangeNotifier {

  late Box box;
  late Map<String, dynamic> userDetails;


  AppSettings(){
    _startSettings();
  }

  _startSettings() async {
    await _startPrefences();
    await _getUserDetails();
  }

  Future<void> _startPrefences() async {
    box = await Hive.openBox('preferencias');
  }

  _getUserDetails() async {

    
  }

  setUserDetails(Map<String, dynamic> userDetails) async {
    await box.put('uid', userDetails['uid']);
    await box.put('name', userDetails['name']);
    await box.put('email', userDetails['email']);
    await box.put('myUBS', userDetails['myUBS']);
    await box.put('accesLevel', userDetails['accesLevel']);
  }
}