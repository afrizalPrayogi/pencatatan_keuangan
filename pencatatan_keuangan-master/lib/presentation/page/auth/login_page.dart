import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pencatatan_keuangan/config/app_asset.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pencatatan_keuangan/config/app_color.dart';
import 'package:pencatatan_keuangan/data/source/source_user.dart';
import 'package:pencatatan_keuangan/presentation/page/auth/register_page.dart';
import 'package:pencatatan_keuangan/presentation/page/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Method Login
  login() async {
    if (formKey.currentState!.validate()) {
      bool success = await SourceUser.login(
        emailController.text,
        passwordController.text,
      );
      if (success) {
        DInfo.dialogSuccess('Berhasil Masuk');

        DInfo.closeDialog(actionAfterClose: () {
          Get.off(() => const HomePage());
        });
      } else {
        DInfo.dialogError('Gagal Masuk');
        DInfo.closeDialog();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lev2,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DView.nothing(),
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          Image.asset(AppAsset.logo),
                          DView.spaceHeight(40),
                          // TEXT FIELD USERNAME
                          TextFormField(
                            validator: (value) =>
                                value == '' ? 'Jangan kosong' : null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: emailController,
                            cursorColor: Colors.white,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              fillColor: AppColor.lev1.withOpacity(0.5),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Email kamu',
                              hintStyle:
                                  GoogleFonts.poppins(color: Colors.white60),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              errorStyle: GoogleFonts.poppins(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          DView.spaceHeight(),

                          // TEXT FIELD PASSWORD
                          TextFormField(
                            validator: (value) =>
                                value == '' ? 'Jangan kosong' : null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: passwordController,
                            obscureText: true,
                            cursorColor: Colors.white,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              fillColor: AppColor.lev1.withOpacity(0.5),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Password kamu',
                              hintStyle:
                                  GoogleFonts.poppins(color: Colors.white60),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              errorStyle: GoogleFonts.poppins(
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // LOGIN
                          DView.spaceHeight(30),
                          Material(
                            color: AppColor.lev1,
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              onTap: () => login(),
                              borderRadius: BorderRadius.circular(30),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                child: Text(
                                  'MASUK',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // REGISTER
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun? ',
                          style: GoogleFonts.poppins(
                              fontSize: 16, color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const RegisterPage());
                          },
                          child: Text(
                            'Daftar',
                            style: GoogleFonts.poppins(
                              color: AppColor.lev4,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
