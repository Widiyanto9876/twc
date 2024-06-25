import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twc/screen/admin/home_screen_admin.dart';
import 'package:twc/screen/login_screen.dart';
import 'package:twc/screen/pegawai/laporan_pegawai.dart';
import 'package:twc/service/preference_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  PreferencesHelper preferencesHelper =
      PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());

  @override
  void initState() {
    _navigator();
    super.initState();
  }

  void _navigator() async {
    String token = '';
    String role = '';
    token = await preferencesHelper.getToken;
    role = await preferencesHelper.getRole;
    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (token.isEmpty) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
            (route) => false,
          );
        } else if (role == "admin") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreenAdmin(),
            ),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LaporanPegawai(),
            ),
            (route) => false,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF838383),
      body: Center(
        child: Image.asset(
          "assets/twc_logo.png",
          width: 200.w,
          height: 80.h,
        ),
      ),
    );
  }
}
