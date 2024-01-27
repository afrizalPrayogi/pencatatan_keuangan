import 'package:d_info/d_info.dart';
import 'package:get/get.dart';
import 'package:pencatatan_keuangan/config/api.dart';
import 'package:pencatatan_keuangan/config/app_request.dart';
import 'package:pencatatan_keuangan/config/session.dart';
import 'package:pencatatan_keuangan/data/model/user.dart';

import '../../presentation/page/auth/login_page.dart';

class SourceUser {
  // login Method
  static Future<bool> login(String email, String password) async {
    String url = '${Api.user}/login.php';
    Map? responBody = await AppRequest.post(url, {
      'email': email,
      'password': password,
    });
    

    // Check Validasi
    if (responBody == null) return false;

    if (responBody['success']) {
      var mapUser = responBody['data'];
      Session.saveUser(User.fromJson(mapUser));
    }

    return responBody['success'];
  }

  // register method
  static Future register(String name, String email, String password) async {
    String url = '${Api.user}/register.php';
    Map? responBody = await AppRequest.post(url, {
      'name': name,
      'email': email,
      'password': password,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    if (responBody == null) return false;

    if (responBody['success']) {
      DInfo.dialogSuccess(
        'Berhasil Register',
      );
      DInfo.closeDialog(actionAfterClose: () {
        Get.off(() => const LoginPage());
      });
    } else {
      if (responBody['message'] == 'email') {
        DInfo.dialogError(
          'Email sudah terdaftar',
        );
      } else {
        DInfo.dialogError(
          'Gagal Register',
        );
      }
      DInfo.closeDialog();
    }

    return responBody['success'];
  }
}
