import 'dart:convert';

import 'package:refine_basic/Model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataStorage{
    static const String _key = "user_data";
    static UserModel? _cachedUserData;

    static Future<void> saveUserData(UserModel userModel) async{
      final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_key, jsonEncode(userModel.toJson()));
        }




    static Future<UserModel?> getUserData() async {
      if (_cachedUserData != null) return _cachedUserData;

      final prefs = await SharedPreferences.getInstance();
      final String? userDataJson = prefs.getString('user_data');
      if (userDataJson != null) {
        _cachedUserData = UserModel.fromJson(jsonDecode(userDataJson));
        return _cachedUserData;
      }
      return null;
    }
}