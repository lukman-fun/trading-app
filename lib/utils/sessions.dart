import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Sessions {
  static Future<void> save(data) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('data', data);
  }

  static Future<String?> get() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('data');
  }

  static Future<void> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove('data');
  }

  static Future<bool> isLoged() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('data') != null ? true : false;
  }

  static Future<String> jwtToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('data') != null
        ? jsonDecode(sharedPreferences.getString('data')!)['authorization']
            ['token']
        : '';
  }
}
