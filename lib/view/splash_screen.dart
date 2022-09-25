import 'dart:async';
import 'package:flutter/material.dart';
import 'package:git_project/constants/r.dart';
import 'package:git_project/helpers/user_helpers.dart';
import 'package:git_project/models/network_response/network_responses.dart';
import 'package:git_project/models/user_by_email.dart';
import 'package:git_project/repository/auth_api.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () async {
        final user = UserHelpers.getUserEmail();

        // print(user == '');

        if (user != '') {
          final dataUser = await AuthAPI().getUserByEmail();

          if (dataUser.status == Status.success) {
            // Masukkan data ke model yang dibuat dengan JSON to DART melalui email yg udah diGET
            final data = UserByEmail.fromJson(dataUser.data!);

            // Cek apakah user sudah pernah login atau belum
            if (data.status == 1) {
              // data.status == 1 itu didapat dari response API
              Navigator.pushReplacementNamed(context, R.appRoutesTO.mainpage);
            } else {
              Navigator.pushNamed(context, R.appRoutesTO.registerpage);
            }
          }
        } else {
          Navigator.pushReplacementNamed(
            //Ini kalau user sama sekali belum login
            context,
            R.appRoutesTO.loginpage,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.primary,
      body: Center(
        child: Image.asset(R.assets.icSplash, scale: 1.5),
      ),
    );
  }
}
