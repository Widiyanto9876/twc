import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twc/screen/admin/list_sector_screen.dart';
import 'package:twc/screen/admin/menu_pegawai_screen.dart';
import 'package:twc/screen/login_screen.dart';
import 'package:twc/service/preference_helper.dart';
import 'package:twc/widgets/base_screen.dart';

class HomeScreenAdmin extends StatelessWidget {
  const HomeScreenAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      text: "Monitoring Pegawai",
      body: Column(
        children: [
          SizedBox(height: 100.h),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MenuPegawai(),
                ),
              );
            },
            child: Container(
              width: 200.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                border: Border.all(
                  color: Colors.black,
                  width: 1.w,
                ),
              ),
              child: Center(
                child: Text(
                  "Menu Pegawai",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 100.h),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListSectorScreen(),
                ),
              );
            },
            child: Container(
              width: 200.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                border: Border.all(
                  color: Colors.black,
                  width: 1.w,
                ),
              ),
              child: Center(
                child: Text(
                  "Laporan Kegiatan",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 100.h),
          InkWell(
            onTap: () {
              removeAllDataPreference().then(
                (value) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
              );
            },
            child: Container(
              width: 200.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                border: Border.all(
                  color: Colors.black,
                  width: 1.w,
                ),
              ),
              child: Center(
                child: Text(
                  "Log Out",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> removeAllDataPreference() async {
    PreferencesHelper preferencesHelper =
        PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());
    preferencesHelper.removeStringSharedPref('token');
    preferencesHelper.removeStringSharedPref("role");
    preferencesHelper.removeStringSharedPref("id");
  }
}
