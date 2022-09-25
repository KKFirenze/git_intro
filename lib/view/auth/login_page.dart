import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:git_project/constants/r.dart';
import 'package:git_project/helpers/preference_helpers.dart';
import 'package:git_project/helpers/user_helpers.dart';
import 'package:git_project/models/network_response/network_responses.dart';
import 'package:git_project/models/user_by_email.dart';
import 'package:git_project/repository/auth_api.dart';
import 'package:git_project/widgets/login_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String route = "login_screen";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithPopup(googleProvider);
    } else {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    R.strings.login,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                R.assets.imgLogin,
                height: constraints.maxWidth >= 920 ? 300 : 250,
              ),
              const SizedBox(height: 35),
              Text(
                R.strings.welcome,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                R.strings.loginDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: R.colors.greySubtitle,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    blurRadius: 60,
                    spreadRadius: 5,
                    color: Colors.black.withOpacity(0.15),
                    offset: const Offset(0, 40),
                  ),
                ]),
                child: LoginButton(
                  backgroundColor: Colors.white,
                  borderColor: R.colors.primary,
                  iconButton: R.assets.icGoogle,
                  child: Text(
                    R.strings.loginWithGoogle,
                    style: TextStyle(
                      color: R.colors.blackLogin,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () async {
                    // INI kalo user login berhasil, ga perlu simpen ke sharedpreference data credential user karena sudah otomatis terisi
                    await signInWithGoogle();
                    final user = UserHelpers.getUserEmail();

                    if (user != null) {
                      final dataUser = await AuthAPI().getUserByEmail();

                      if (dataUser.status == Status.success) {
                        // Masukkan data ke model yang dibuat dengan JSON to DART melalui email yg udah diGET
                        final data = UserByEmail.fromJson(dataUser.data!);

                        // Cek apakah user sudah pernah login atau belum
                        // data.status == 1 itu didapat dari response API
                        if (data.status == 1) {
                          /* simpan data user ke local dengan SharedPref yang sudah disetting di PreferenceHelpers
                           apabila user sudah pernah register atau status 1, maka simpan datanya ke local,
                           Kalau belum pernah register, nanti datanya disimpan ke local barengan waktu register ke API
                          */
                          await PreferenceHelpers().setUserData(data.data!);
                          Navigator.pushReplacementNamed(
                              context, R.appRoutesTO.mainpage);
                        } else {
                          Navigator.pushNamed(
                              context, R.appRoutesTO.registerpage);
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Gagal Masuk'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                ),
              ),
              if (Platform.isIOS)
                LoginButton(
                  backgroundColor: R.colors.blackLogin,
                  borderColor: Colors.white,
                  iconButton: R.assets.icApple,
                  child: Text(
                    R.strings.loginWithApple,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {},
                ),
            ],
          ),
        );
      }),
    );
  }
}
