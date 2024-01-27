import 'dart:io';
//import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../data/source/source_history.dart';

class HomeController extends GetxController {
  final _today = 0.0.obs;
  double get today => _today.value;

  final _todayPercent = ''.obs;
  String get todayPercent => _todayPercent.value;

  final _week = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0].obs;
  List<double> get week => _week.toList();

  List<String> get days => ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
  List<String> weekText() {
    DateTime today = DateTime.now();
    return [
      days[today.subtract(const Duration(days: 6)).weekday - 1],
      days[today.subtract(const Duration(days: 5)).weekday - 1],
      days[today.subtract(const Duration(days: 4)).weekday - 1],
      days[today.subtract(const Duration(days: 3)).weekday - 1],
      days[today.subtract(const Duration(days: 2)).weekday - 1],
      days[today.subtract(const Duration(days: 1)).weekday - 1],
      days[today.weekday - 1],
    ];
  }

  final _monthIncome = 0.0.obs;
  double get monthIncome => _monthIncome.value;

  final _monthOutcome = 0.0.obs;
  double get monthOutcome => _monthOutcome.value;

  final _percentIncome = '0'.obs;
  String get percentIncome => _percentIncome.value;

  final _monthPercent = ''.obs;
  String get monthPercent => _monthPercent.value;

  final _differentMonth = 0.0.obs;
  double get differentMonth => _differentMonth.value;

  getAnalysis(String idUser) async {
    Map data = await SourceHistory.analysis(idUser);
    double monthIncome = data['month']['income'].toDouble();
    double monthOutcome = data['month']['outcome'].toDouble();

    // Memanggil fungsi getPDF untuk mencetak laporan
    getPDF(idUser, monthIncome, monthOutcome);
    // today outcome
    _today.value = data['today'].toDouble();
    double yesterday = data['yesterday'].toDouble();
    double different = (today - yesterday).abs();
    bool isSame = today.isEqual(yesterday);
    bool isPlus = today.isGreaterThan(yesterday);
    double dividerToday = (today + yesterday) == 0 ? 1 : (today + yesterday);
    double percent = (different / dividerToday) * 100;
    _todayPercent.value = isSame
        ? '100% sama dengan kemarin'
        : isPlus
            ? '+${percent.toStringAsFixed(1)}% dibanding kemarin'
            : '-${percent.toStringAsFixed(1)}% dibanding kemarin';

    _week.value = List.castFrom(data['week'].map((e) => e.toDouble()).toList());

    _monthIncome.value = data['month']['income'].toDouble();
    _monthOutcome.value = data['month']['outcome'].toDouble();
    _differentMonth.value = (monthIncome - monthOutcome).abs();
    bool isSameMonth = monthIncome.isEqual(monthOutcome);
    bool isPlusMonth = monthIncome.isGreaterThan(monthOutcome);
    double dividerMonth =
        (monthIncome + monthOutcome) == 0 ? 1 : (monthIncome + monthOutcome);
    double percentMonth = (differentMonth / dividerMonth) * 100;
    _percentIncome.value = percentMonth.toStringAsFixed(1);
    _monthPercent.value = isSameMonth
        ? 'Pemasukan\n100% sama\ndengan Pengeluaran'
        : isPlusMonth
            ? 'Pemasukan\nlebih besar $percentIncome%\ndari Pengeluaran'
            : 'Pemasukan\nlebih kecil $percentIncome%\ndari Pengeluaran';
  }

  void getPDF(String idUser, double income, double outcome) async {
    // Buat dokumen PDF
    final pdf = pw.Document();

    
    final customFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/OpenSans.ttf"),
    );

    
    final customTextStyle = pw.TextStyle(
      font: customFont,
      fontSize: 14, 
      color: PdfColors.black, 
    );

    // Tambahkan halaman ke PDF
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Laporan Keuangan Minggu Ini',
                style: pw.TextStyle(
                  font: customFont,
                  fontSize: 24, 
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Text(
                'ID User: $idUser',
                style: customTextStyle, 
              ),
              pw.SizedBox(height: 12),
              pw.Text(
                'Pemasukan: ${income.toStringAsFixed(2)}',
                style: customTextStyle, 
              ),
              pw.Text(
                'Pengeluaran: ${outcome.toStringAsFixed(2)}',
                style: customTextStyle, 
              ),
            ],
          );
        },
      ),
    );

    // Simpan PDF ke dalam bytes
    // ignore: non_constant_identifier_names
    final Uint8List = await pdf.save();

    // Buat file kosong di direktori perangkat
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/Documents.pdf');

    // Timpa file yang kosong dengan file PDF
    await file.writeAsBytes(Uint8List);

    // Buka file PDF
    await OpenFile.open(file.path);
  }
}
