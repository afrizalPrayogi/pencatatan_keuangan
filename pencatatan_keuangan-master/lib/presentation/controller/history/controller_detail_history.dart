import 'package:get/get.dart';
import 'package:pencatatan_keuangan/data/model/history.dart';
import 'package:pencatatan_keuangan/data/source/source_history.dart';

class DetailHistoryController extends GetxController {
  final _data = History().obs;
  History get data => _data.value;

  getData(idUser, date, type) async {
    History? history = await SourceHistory.detail(idUser, date, type);
    _data.value = history ?? History();
    update();
  }
}
