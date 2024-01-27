import 'package:get/get.dart';
import 'package:pencatatan_keuangan/data/model/history.dart';
import 'package:pencatatan_keuangan/data/source/source_history.dart';

class IncomeOutcomeController extends GetxController {
  final _list = <History>[].obs;
  List<History> get list => _list.toList();

  final _loading = false.obs;
  bool get loading => _loading.value;

  getList(idUser, type) async {
    _loading.value = true;
    update();

    _list.value = await SourceHistory.incomeOutcome(idUser, type);
    update();

    Future.delayed(const Duration(milliseconds: 900), () {
      _loading.value = false;
      update();
    });
  }

  search(idUser, type, date) async {
    _loading.value = true;
    update();

    _list.value = await SourceHistory.incomeOutcomeSearch(idUser, type, date);
    update();

    Future.delayed(const Duration(microseconds: 900), () {
      _loading.value = false;
      update();
    });
  }
}
