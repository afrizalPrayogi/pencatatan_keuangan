import 'package:get/get.dart';
import 'package:pencatatan_keuangan/data/model/user.dart';

class UserController extends GetxController {
  final _data = User().obs;
  User get data => _data.value;
  setData(dynamic n) => _data.value = n;
}
