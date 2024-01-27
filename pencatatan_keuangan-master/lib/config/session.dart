import 'dart:convert';
import 'package:get/get.dart';
import 'package:pencatatan_keuangan/presentation/controller/controller_user.dart';
import 'package:pencatatan_keuangan/data/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static Future<bool> saveUser(User user) async {
    final pref = await SharedPreferences.getInstance();
    Map<String, dynamic> mapUser = user.toJson();
    String stringUser = jsonEncode(mapUser);
    bool success = await pref.setString('user', stringUser);
    if (success) {
      final controllerUser = Get.put(UserController());
      controllerUser.setData(user);
    }
    return success;
  }

  static Future<User> getUser() async {
    User user = User(); // default value
    final pref = await SharedPreferences.getInstance();
    String? stringUser = pref.getString('user');
    if (stringUser != null) {
      Map<String, dynamic> mapUser = jsonDecode(stringUser);
      user = User.fromJson(mapUser);
    }
    final controllerUser = Get.put(UserController());
    controllerUser.setData(user);
    return user;
  }

  static Future<bool> clearUser() async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.remove('user');
    final controllerUser = Get.put(UserController());
    controllerUser.setData(User());
    return success;
  }
}
