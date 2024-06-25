import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twc/screen/admin/add_pegawai_screen.dart';
import 'package:twc/screen/admin/list_user_screen.dart';
import 'package:twc/widgets/base_screen.dart';

class MenuPegawai extends StatelessWidget {
  const MenuPegawai({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      text: "Daftar Pegawai",
      body: Column(
        children: [
          SizedBox(height: 100.h),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPegawaiScreen(),
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
                  "Tambah Pegawai",
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
                  builder: (context) => const ListUserScreen(
                    isFormEditDataPegawai: true,
                  ),
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
                  "Edit Data Pegawai",
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
              Navigator.pop(context);
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
                  "Kembali",
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
}
