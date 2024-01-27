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
import 'package:pencatatan_keuangan/presentation/controller/history/controller_income_outcome.dart';
import 'package:pencatatan_keuangan/package/my_package.dart';
import 'package:pencatatan_keuangan/presentation/page/history/detail_history_page.dart';
import 'package:pencatatan_keuangan/presentation/page/history/update_history_page.dart';

class IncomeOutcomePage extends StatefulWidget {
  const IncomeOutcomePage({super.key, required this.type});

  final String type;

  @override
  State<IncomeOutcomePage> createState() => _IncomeOutcomePageState();
}

class _IncomeOutcomePageState extends State<IncomeOutcomePage> {
  final incomeOutcomeController = Get.put(IncomeOutcomeController());
  final userController = Get.put(UserController());
  final searchController = TextEditingController();

  refresh() {
    incomeOutcomeController.getList(userController.data.idUser, widget.type);
  }

  menuOption(String value, History history) async {
    if (value == 'update') {
      Get.to(() => UpdateHistoryPage(
          date: history.date!, idHistory: history.idHistory!))?.then((value) {
        if (value ?? false) {
          refresh();
        }
      });
    } else if (value == 'delete') {
      bool? isDelete = await MyPackage.dialogConfirmation(
        context,
        title: 'Hapus',
        content: 'Yakin ingin menghapus history ini?',
        myStyle: GoogleFonts.poppins(),
      );
      if (isDelete!) {
        bool success = await SourceHistory.delete(history.idHistory!);
        if (success) refresh();
      }
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
                margin: const EdgeInsets.all(16),
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
                      onPressed: () {
                        incomeOutcomeController.search(
                          userController.data.idUser,
                          widget.type,
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
                      vertical: 0,
                      horizontal: 20,
                    ),
                    hintText: AppFormat.date(DateTime.now().toString()),
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
      body: GetBuilder<IncomeOutcomeController>(builder: (ctx) {
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
                        PopupMenuButton<String>(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'update',
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Update',
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.update,
                                    color: Color(0xff83D290),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Delete',
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.delete_forever,
                                    color: Color(0XFFFF7171),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) => menuOption(value, history),
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
