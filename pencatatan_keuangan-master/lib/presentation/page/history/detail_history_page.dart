import 'dart:convert';

import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pencatatan_keuangan/config/app_color.dart';
import 'package:pencatatan_keuangan/config/app_format.dart';
import 'package:pencatatan_keuangan/presentation/controller/history/controller_detail_history.dart';

class DetailHistoryPage extends StatefulWidget {
  const DetailHistoryPage(
      {super.key,
      required this.idUser,
      required this.date,
      required this.type});

  final String idUser;
  final String date;
  final String type;
  @override
  State<DetailHistoryPage> createState() => _DetailHistoryPageState();
}

class _DetailHistoryPageState extends State<DetailHistoryPage> {
  final detailHistoryController = Get.put(DetailHistoryController());

  @override
  void initState() {
    detailHistoryController.getData(widget.idUser, widget.date, widget.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Obx(() {
          if (detailHistoryController.data.date == null) return DView.nothing();
          return Row(
            children: [
              Expanded(
                child: Text(
                  AppFormat.date(detailHistoryController.data.date!),
                ),
              ),
              detailHistoryController.data.type == 'Pemasukan'
                  ? Icon(Icons.south_west, color: Colors.green[300])
                  : Icon(Icons.north_east, color: Colors.red[300]),
              DView.spaceWidth(),
            ],
          );
        }),
      ),
      body: GetBuilder<DetailHistoryController>(
        builder: (_) {
          if (_.data.date == null) {
            String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
            if (widget.date == today && widget.type == 'Pengeluaran') {
              return DView.empty('Belum ada Pengeluaran');
            }

            return DView.nothing();
          }
          List details = jsonDecode(_.data.details!);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  'Total',
                  style: GoogleFonts.poppins(
                    color: AppColor.lev1,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Text(
                  AppFormat.currency(_.data.total!),
                  style: GoogleFonts.poppins(
                    color: AppColor.lev1,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
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
              DView.spaceHeight(20),
              Expanded(
                child: ListView.separated(
                  itemCount: details.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    thickness: 0.5,
                  ),
                  itemBuilder: (context, index) {
                    Map item = details[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                      child: Row(
                        children: [
                          Text(
                            '${index + 1}.',
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          DView.spaceWidth(8),
                          Expanded(
                            child: Text(
                              item['name'],
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                          ),
                          Text(
                            AppFormat.currency(item['price']),
                            style: GoogleFonts.poppins(
                                fontSize: 16, color: AppColor.lev3),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
