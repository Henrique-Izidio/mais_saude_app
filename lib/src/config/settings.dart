import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  // ignore: non_constant_identifier_names
  late SharedPreferences _DBPreferences;
  Map<String, dynamic> preferences = {
    'darkTheme' : false,
  };

  AppSettings(){
    _startSettings();
  }

  _startSettings() async {
    _startPreferences();
    _readPreferences();
  }

  Future<void> _startPreferences() async {
    _DBPreferences = await SharedPreferences.getInstance();
  }

  _readPreferences(){
    final darkTheme = _DBPreferences.getBool('darkTheme') ?? false;

    preferences = {
      'darkTheme' : darkTheme,
    };

    notifyListeners();
  }

  setTheme(bool isDarkTheme) async {
    await _DBPreferences.setBool('DarkTheme', isDarkTheme);
  }
}