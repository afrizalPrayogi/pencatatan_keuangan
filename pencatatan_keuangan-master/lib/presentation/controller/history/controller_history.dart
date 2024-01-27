import 'package:get/get.dart';
import 'package:pencatatan_keuangan/data/model/history.dart';
import 'package:pencatatan_keuangan/data/source/source_history.dart';

class HistoryController extends GetxController {
  final _loading = false.obs;
  bool get loading => _loading.value;

  final _list = <History>[].obs;
  List<History> get list => _list.toList();

  getList(idUser) async {
    _loading.value = true;
    update();

    _list.value = await SourceHistory.history(idUser);
    update();

    Future.delayed(const Duration(milliseconds: 900), () {
      _loading.value = false;
      update();
    });
  }

  search(idUser, date) async {
    _loading.value = true;
    update();

    _list.value = await SourceHistory.historySearch(idUser, date);
    update();

    Future.delayed(const Duration(milliseconds: 900), () {
      _loading.value = false;
      update();
    });
  }
}
