import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pencatatan_keuangan/config/app_color.dart';
import 'package:pencatatan_keuangan/presentation/controller/controller_home.dart';
import 'package:pencatatan_keuangan/presentation/controller/controller_user.dart';
import 'package:pencatatan_keuangan/presentation/widget/home_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeController = Get.put(HomeController());
  final userController = Get.put(UserController());
  final homeWidget = Get.put(HomeWidget());

  refresh() {
    homeController.getAnalysis(userController.data.idUser!);
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: homeWidget.drawerBuilder(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            children: [
              homeWidget.buildHeader(),
              // Content
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    refresh();
                  },
                  child: ListView(
                    children: [
                      homeWidget.buildTodayExpenses(),
                      DView.spaceHeight(30),
                      Center(
                        child: myDivider(),
                      ),
                      homeWidget.buildWeeklyExpenses(),
                      DView.spaceHeight(16),
                      homeWidget.buildMonthlyComparison(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String? idUser = userController.data.idUser ?? '';
          double monthIncome = homeController.monthIncome;
          double monthOutcome = homeController.monthOutcome;

          homeController.getPDF(idUser, monthIncome, monthOutcome);
        },
        child: const Icon(Icons.note),
      ),
    );
  }

  Container myDivider() {
    return Container(
      height: 6,
      width: 72,
      decoration: BoxDecoration(
        color: AppColor.lev3,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
