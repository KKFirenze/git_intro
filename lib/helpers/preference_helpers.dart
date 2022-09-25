import 'dart:convert';

import 'package:git_project/models/user_by_email.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelpers {
  static String userData = 'user_data';

  Future<SharedPreferences> _sharedPref() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences;
  }

  Future _saveString(key, data) async {
    final pref = await _sharedPref();
    await pref.setString(key, data);
  }

  Future _getString(key) async {
    final pref = await _sharedPref();
    return pref.getString(key);
  }

  Future setUserData(UserData userDataModel) async {
    final json = userDataModel.toJson();

    final userDataString = jsonEncode(json);

    await _saveString(userData, userDataString);
  }

  Future<UserData?> getUserData() async {
    final user = await _getString(userData);

    final userDataJson = jsonDecode(user);
    final userDataModel = UserData.fromJson(userDataJson);
    return userDataModel;
  }
}
