import 'dart:convert';

import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pencatatan_keuangan/config/app_color.dart';
import 'package:pencatatan_keuangan/config/app_format.dart';
import 'package:pencatatan_keuangan/data/source/source_history.dart';
import 'package:pencatatan_keuangan/presentation/controller/controller_user.dart';
import 'package:pencatatan_keuangan/presentation/controller/history/controller_update_history.dart';

class UpdateHistoryPage extends StatefulWidget {
  const UpdateHistoryPage(
      {super.key, required this.date, required this.idHistory});

  final String date;
  final String idHistory;

  @override
  State<UpdateHistoryPage> createState() => _UpdateHistoryPageState();
}

class _UpdateHistoryPageState extends State<UpdateHistoryPage> {
  final controllerUpdateHistory = Get.put(UpdateHistoryController());
  final controllerUser = Get.put(UserController());
  final controllerName = TextEditingController();
  final controollerPrice = TextEditingController();

  updateHistory() async {
    bool success = await SourceHistory.update(
      widget.idHistory,
      controllerUser.data.idUser!,
      controllerUpdateHistory.date,
      controllerUpdateHistory.type,
      jsonEncode(controllerUpdateHistory.items),
      controllerUpdateHistory.total.toString(),
    );

    if (success) {
      Future.delayed(
        const Duration(milliseconds: 3000),
        () => Get.back(result: true),
      );
    }
  }

  @override
  void initState() {
    controllerUpdateHistory.init(controllerUser.data.idUser, widget.date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Text(
            'Update',
            style: GoogleFonts.poppins(),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Tanggal',
              style: GoogleFonts.poppins(),
            ),
            Row(
              children: [
                Obx(() {
                  return Text(
                    controllerUpdateHistory.date,
                    style: GoogleFonts.poppins(fontSize: 18),
                  );
                }),
                DView.spaceWidth(),
                ElevatedButton.icon(
                  onPressed: () async {
                    DateTime? result = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023, 01, 01),
                      lastDate: DateTime(DateTime.now().year + 1),
                    );
                    if (result != null) {
                      controllerUpdateHistory
                          .setDate(DateFormat('yyyy-MM-dd').format(result));
                    }
                  },
                  icon: const Icon(Icons.event),
                  label: Text(
                    'Pilih',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              ],
            ),
            // Tipe
            DView.spaceHeight(),
            Obx(() {
              return InputDecorator(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  border: const OutlineInputBorder(),
                  label: const Text('Tipe history'),
                  labelStyle: GoogleFonts.poppins(),
                ),
                child: DropdownButton(
                  value: controllerUpdateHistory.type,
                  items: ['Pemasukan', 'Pengeluaran'].map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: GoogleFonts.poppins(),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    controllerUpdateHistory.setType(value);
                  },
                  isExpanded: true,
                  underline: Container(),
                  isDense: true,
                  borderRadius: BorderRadius.circular(16),
                ),
              );
            }),
            // Subject or object
            DView.spaceHeight(24),
            DInput(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              controller: controllerName,
              hint: 'Jualan',
              // title: 'Sumber/Object Pengeluaran',
              style: GoogleFonts.poppins(),
              label: 'Sumber/Object Pengeluaran',
            ),
            // Price
            DView.spaceHeight(24),
            DInput(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              controller: controollerPrice,
              hint: '10000',
              // title: 'Sumber/Object Pengeluaran',
              style: GoogleFonts.poppins(),
              label: 'Harga',
              inputType: TextInputType.number,
            ),
            // Add button
            DView.spaceHeight(),
            ElevatedButton(
              onPressed: () {
                controllerUpdateHistory.addItem({
                  'name': controllerName.text,
                  'price': controollerPrice.text,
                });
                controllerName.clear();
                controollerPrice.clear();
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Tambah ke item',
                  style: GoogleFonts.poppins(),
                ),
              ),
            ),
            DView.spaceHeight(),
            // Divider
            Center(
              child: Container(
                height: 6,
                width: 72,
                decoration: BoxDecoration(
                  color: AppColor.lev3,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            // Items
            DView.spaceHeight(24),
            Text(
              'Jumlah item',
              style: GoogleFonts.poppins(),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: GetBuilder<UpdateHistoryController>(
                builder: (context) {
                  return Wrap(
                    runSpacing: 0,
                    spacing: 8,
                    children: List.generate(context.items.length, (index) {
                      return Chip(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        backgroundColor: Colors.transparent,
                        label: Text(context.items[index]['name']),
                        deleteIcon: const Icon(
                          Icons.clear,
                          color: Colors.red,
                          size: 22,
                        ),
                        onDeleted: () => context.deleteItem(index),
                        labelStyle: GoogleFonts.poppins(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Colors.grey),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
            // Total
            DView.spaceHeight(),
            Row(
              children: [
                Text(
                  'Total:',
                  style: GoogleFonts.poppins(),
                ),
                DView.spaceWidth(10),
                Obx(() {
                  return Text(
                    AppFormat.currency(
                        controllerUpdateHistory.total.toString()),
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.lev1,
                    ),
                  );
                }),
              ],
            ),
            // Submit
            Container(
              margin: const EdgeInsets.fromLTRB(0, 60, 0, 10),
              child: ElevatedButton(
                style: const ButtonStyle(
                  elevation: MaterialStatePropertyAll(8),
                ),
                onPressed: () => updateHistory(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                  child: Text(
                    'SUBMIT',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
