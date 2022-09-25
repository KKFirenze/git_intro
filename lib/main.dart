import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:git_project/constants/r.dart';
import 'package:git_project/firebase_options.dart';
import 'package:git_project/providers/banner_provider.dart';
import 'package:git_project/providers/chat_provider.dart';
import 'package:git_project/providers/kerjakan_soal_list_provider.dart';
import 'package:git_project/providers/latihan_soal_skor_provider.dart';
import 'package:git_project/providers/mapel_provider.dart';
import 'package:git_project/providers/paket_soal_list_provider.dart';
import 'package:git_project/providers/user_provider.dart';
import 'package:git_project/view/auth/login_page.dart';
import 'package:git_project/view/main/discussion/chat_page.dart';
import 'package:git_project/view/main/latihan_soal/home_page.dart';
import 'package:git_project/view/main/latihan_soal/kerjakan_latihan_soal_page.dart';
import 'package:git_project/view/main/latihan_soal/mapel_page.dart';
import 'package:git_project/view/main/latihan_soal/paket_soal_page.dart';
import 'package:git_project/view/main/profile/edit_profile_page.dart';
import 'package:git_project/view/main/profile/profile_page.dart';
import 'package:git_project/view/main_page.dart';
import 'package:git_project/view/auth/register_page.dart';
import 'package:git_project/view/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(
      //options: DefaultFirebaseOptions.currentPlatform,
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MapelProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BannerProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PaketSoalListProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => KerjakanSoalListProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LatihanSoalSkorProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Latihan Soal',
        theme: ThemeData(
          appBarTheme: AppBarTheme(backgroundColor: R.colors.primary),
          textTheme: GoogleFonts.poppinsTextTheme(),
          scaffoldBackgroundColor: R.colors.grey,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: R.colors.primary,
          ),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
              .copyWith(secondary: R.colors.primary),
        ),
        //home: const SplashScreen(),
        initialRoute: R.appRoutesTO.splashscreen,
        routes: {
          // Splash, Login, Register
          R.appRoutesTO.splashscreen: (context) => const SplashScreen(),
          R.appRoutesTO.loginpage: (context) => const LoginPage(),
          R.appRoutesTO.registerpage: (context) => const RegisterPage(),

          // Home
          R.appRoutesTO.mainpage: (context) => const MainPage(),
          R.appRoutesTO.homepage: (context) => const HomePage(),
          R.appRoutesTO.chatpage: (context) => const ChatPage(),
          R.appRoutesTO.profilepage: (context) => const ProfilePage(),

          // Latihan soal
          R.appRoutesTO.mapelpage: (context) => const MapelPage(),
          R.appRoutesTO.paketSoalpage: (context) => const PaketSoalPage(),
          R.appRoutesTO.kerjakanSoalpage: (context) =>
              const KerjakanLatihanSoalPage(),

          // Profile
          R.appRoutesTO.editProfilepage: (context) => const EditProfilePage(),
          // SplashScreen.route: (context) => const SplashScreen(),
          // LoginPage.route: (context) => const LoginPage(),
          // RegisterPage.route: (context) => const RegisterPage(),
          // MainPage.route: (context) => const MainPage(),
          // KerjakanLatihanSoalPage.route: (context) =>
          //     const KerjakanLatihanSoalPage(),
          //MapelPage.route: (context) => const MapelPage(),
          //PaketSoalPage.route: (context) => const PaketSoalPage(),
        },
      ),
    );
  }
}
