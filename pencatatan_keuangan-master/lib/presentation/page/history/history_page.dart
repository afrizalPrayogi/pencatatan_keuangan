import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pencatatan_keuangan/config/app_color.dart';
import 'package:pencatatan_keuangan/config/app_format.dart';
import 'package:pencatatan_keuangan/data/model/history.dart';
import 'package:pencatatan_keuangan/data/source/source_history.dart';
import 'package:pencatatan_keuangan/presentation/controller/controller_user.dart';
import 'package:pencatatan_keuangan/presentation/controller/history/controller_history.dart';
import 'package:pencatatan_keuangan/presentation/controller/history/controller_income_outcome.dart';
import 'package:pencatatan_keuangan/package/my_package.dart';
import 'package:pencatatan_keuangan/presentation/page/history/detail_history_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.type});

  final String type;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final incomeOutcomeController = Get.put(IncomeOutcomeController());
  final historyController = Get.put(HistoryController());
  final userController = Get.put(UserController());
  final searchController = TextEditingController();

  refresh() {
    historyController.getList(userController.data.idUser);
  }

  delete(String idHistory) async {
    bool? isDelete = await MyPackage.dialogConfirmation(
      context,
      title: 'Hapus',
      content: 'Yakin ingin menghapus history ini?',
      myStyle: GoogleFonts.poppins(),
    );
    if (isDelete!) {
      bool success = await SourceHistory.delete(idHistory);
      if (success) refresh();
    }
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            // Title
            Text(
              widget.type,
              style: GoogleFonts.poppins(),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(40, 16, 20, 16),
                height: 40,
                child: TextField(
                  controller: searchController,
                  onTap: () async {
                    DateTime? result = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023, 01, 01),
                      lastDate: DateTime(DateTime.now().year + 1),
                    );

                    if (result != null) {
                      searchController.text =
                          DateFormat('yyyy-MM-dd').format(result);
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColor.lev3.withOpacity(0.5),
                    isDense: false,
                    suffixIcon: IconButton(
                      padding: const EdgeInsets.only(right: 4),
                      onPressed: () {
                        historyController.search(
                          userController.data.idUser,
                          searchController.text,
                        );
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    hintText: 'Cari riwayat...',
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  style: GoogleFonts.poppins(color: Colors.white),
                  cursorColor: Colors.white,
                  textAlignVertical: TextAlignVertical.center,
                ),
              ),
            ),
          ],
        ),
      ),
      // Content body
      body: GetBuilder<HistoryController>(builder: (ctx) {
        if (ctx.loading) return DView.loadingCircle();
        if (ctx.list.isEmpty) return DView.empty('Kosong');
        return RefreshIndicator(
          onRefresh: () async => refresh(),
          child: ListView.builder(
            itemCount: ctx.list.length,
            itemBuilder: (context, index) {
              History history = ctx.list[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.fromLTRB(
                  20,
                  index == 0 ? 16 : 8,
                  20,
                  index == ctx.list.length - 1 ? 16 : 8,
                ),
                child: InkWell(
                  onTap: () {
                    Get.to(() => DetailHistoryPage(
                          idUser: userController.data.idUser!,
                          date: history.date!,
                          type: history.type!,
                        ));
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        DView.spaceWidth(),
                        history.type == 'Pemasukan'
                            ? Icon(Icons.south_west, color: Colors.green[300])
                            : Icon(Icons.north_east, color: Colors.red[300]),
                        DView.spaceWidth(),
                        Text(
                          AppFormat.date(history.date!),
                          style: GoogleFonts.poppins(
                            color: AppColor.lev1,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            AppFormat.currency(history.total!),
                            style: GoogleFonts.poppins(
                              color: AppColor.lev3,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        IconButton(
                          onPressed: () => delete(history.idHistory!),
                          icon: Icon(Icons.delete_forever,
                              color: Colors.red[300]),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
