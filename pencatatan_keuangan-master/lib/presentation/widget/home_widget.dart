import 'package:d_chart/d_chart.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pencatatan_keuangan/presentation/controller/controller_home.dart';
import 'package:pencatatan_keuangan/presentation/controller/controller_user.dart';
import 'package:pencatatan_keuangan/presentation/page/history/add_history_page.dart';
import 'package:pencatatan_keuangan/presentation/page/history/detail_history_page.dart';
import 'package:pencatatan_keuangan/presentation/page/history/history_page.dart';
import 'package:pencatatan_keuangan/presentation/page/history/income_outcome_page.dart';
import '../../config/app_asset.dart';
import '../../config/app_color.dart';
import '../../config/app_format.dart';
import '../../config/session.dart';
import '../page/auth/login_page.dart';

class HomeWidget {
  final userController = Get.put(UserController());
  final homeController = Get.put(HomeController());
  

  Widget drawerBuilder() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            margin: const EdgeInsets.only(bottom: 0),
            padding: const EdgeInsets.fromLTRB(20, 0, 16, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      AppAsset.profile,
                      width: 70,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => Text(
                              userController.data.name ?? '',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Obx(
                            () => Text(
                              userController.data.email ?? '',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Logout
                DView.spaceHeight(10),
                ElevatedButton(
                  onPressed: () {
                    // clear session and going to login page.
                    Session.clearUser();
                    Get.off(() => const LoginPage());
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 24,
                    ),
                    elevation: 6,
                    backgroundColor: AppColor.lev1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Keluar',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Get.to(() => AddHistoryPage());
            },
            leading: const Icon(Icons.add),
            horizontalTitleGap: 0,
            title: Text(
              'Tambah Baru',
              style: GoogleFonts.poppins(
                fontSize: 16,
              ),
            ),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(height: 0.5),
          ListTile(
            onTap: () {
              Get.to(() => const IncomeOutcomePage(type: 'Pemasukan'));
            },
            leading: const Icon(Icons.south_west),
            horizontalTitleGap: 0,
            title: Text(
              'Pemasukan',
              style: GoogleFonts.poppins(
                fontSize: 16,
              ),
            ),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(height: 0.5),
          ListTile(
            onTap: () {
              Get.to(() => const IncomeOutcomePage(type: 'Pengeluaran'));
            },
            leading: const Icon(Icons.north_east),
            horizontalTitleGap: 0,
            title: Text(
              'Pengeluaran',
              style: GoogleFonts.poppins(
                fontSize: 16,
              ),
            ),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(height: 0.5),
          ListTile(
            onTap: () {
              Get.to(() => const HistoryPage(type: 'Riwayat'));
            },
            leading: const Icon(Icons.history),
            horizontalTitleGap: 0,
            title: Text(
              'Riwayat',
              style: GoogleFonts.poppins(
                fontSize: 16,
              ),
            ),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(height: 0.5),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      children: [
        Image.asset(
          AppAsset.profile,
          width: 70,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi,',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColor.lev1,
                ),
              ),
              Obx(
                () => Text(
                  userController.data.name ?? '',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColor.lev1,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Menu button
        Builder(builder: (drawer) {
          return InkWell(
            onTap: () => Scaffold.of(drawer).openEndDrawer(),
            child: const Icon(
              Icons.menu_rounded,
              color: AppColor.lev1,
              size: 20 * 2,
            ),
          );
        })
      ],
    );
  }

  Widget buildTodayExpenses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Text(
            'Pengeluaran Hari Ini',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.lev1,
            ),
          ),
        ),
        DView.spaceHeight(),
        _buildCardToday()
      ],
    );
  }

  Widget _buildCardToday() {
    return Material(
      color: AppColor.lev1,
      borderRadius: BorderRadius.circular(14),
      elevation: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
            child: Obx(() {
              return Text(
                AppFormat.currency(homeController.today.toString()),
                style: GoogleFonts.poppins(
                  color: AppColor.lev4,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
            child: Obx(() {
              return Text(
                homeController.todayPercent,
                style: GoogleFonts.poppins(
                  color: AppColor.lev3,
                ),
              );
            }),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 0, 16),
            child: InkWell(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              onTap: () {
                Get.to(() => DetailHistoryPage(
                      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                      idUser: userController.data.idUser!,
                      type: 'Pengeluaran',
                    ));
              },
              child: Ink(
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Selengkapnya',
                      style: GoogleFonts.poppins(
                        color: AppColor.lev1,
                        fontSize: 16,
                      ),
                    ),
                    const Icon(
                      Icons.navigate_next,
                      color: AppColor.lev1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWeeklyExpenses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Text(
            'Pengeluaran Minggu Ini',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.lev1,
            ),
          ),
        ),
        DView.spaceHeight(),
        _buildChartWeekly()
      ],
    );
  }

  Widget _buildChartWeekly() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Obx(() {
        return DChartBar(
          data: [
            {
              'id': 'Bar',
              'data': List.generate(7, (index) {
                return {
                  'domain': homeController.weekText()[index],
                  'measure': homeController.week[index]
                };
              })
            },
          ],
          domainLabelPaddingToAxisLine: 16,
          axisLineTick: 1,
          axisLinePointTick: 1,
          axisLinePointWidth: 8,
          axisLineColor: AppColor.lev1,
          measureLabelPaddingToAxisLine: 16,
          barColor: (barData, index, id) => AppColor.lev1,
          showBarValue: true,
        );
      }),
    );
  }

  Widget buildMonthlyComparison(BuildContext ctx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Text(
            'Perbandingan Bulan Ini',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.lev1,
            ),
          ),
        ),
        DView.spaceHeight(),
        _buildMonthlyChart(ctx)
      ],
    );
  }

  Widget _buildMonthlyChart(BuildContext ctx) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(ctx).size.width * 0.5,
          height: MediaQuery.of(ctx).size.width * 0.5,
          child: Stack(
            children: [
              Obx(() {
                return DChartPie(
                  data: [
                    {'domain': 'income', 'measure': homeController.monthIncome},
                    {
                      'domain': 'outcome',
                      'measure': homeController.monthOutcome
                    },
                    // if month income and month outcome = 0
                    if (homeController.monthIncome == 0 &&
                        homeController.monthOutcome == 0)
                      {'domain': 'nol', 'measure': 1},
                  ],
                  fillColor: (pieData, index) {
                    switch (pieData['domain']) {
                      case 'income':
                        return AppColor.lev3;
                      case 'outcome':
                        return AppColor.lev1;
                      default:
                        return AppColor.lev2.withOpacity(0.5);
                    }
                  },
                  donutWidth: 24,
                  labelFontSize: 0,
                );
              }),
              // Percentage
              Center(
                child: Obx(() {
                  return Text(
                    '${homeController.percentIncome}%',
                    style: GoogleFonts.poppins(
                      color: AppColor.lev3,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        DView.spaceWidth(8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 16,
                  width: 16,
                  color: AppColor.lev1,
                ),
                DView.spaceWidth(8),
                Text(
                  'Pengeluaran',
                  style: GoogleFonts.poppins(),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  height: 16,
                  width: 16,
                  color: AppColor.lev3,
                ),
                DView.spaceWidth(8),
                Text(
                  'Pemasukan',
                  style: GoogleFonts.poppins(),
                ),
              ],
            ),
            DView.spaceHeight(10),
            Obx(() {
              return Text(
                homeController.monthPercent,
                style: GoogleFonts.poppins(),
              );
            }),
            DView.spaceHeight(10),
            Text(
              'Atau setara',
              style: GoogleFonts.poppins(),
            ),
            Obx(() {
              return Text(
                AppFormat.currency(homeController.differentMonth.toString()),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColor.lev1,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}
