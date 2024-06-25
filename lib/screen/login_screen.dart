import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twc/screen/admin/home_screen_admin.dart';
import 'package:twc/screen/pegawai/laporan_pegawai.dart';
import 'package:twc/service/pegawai_service.dart';
import 'package:twc/service/preference_helper.dart';
import 'package:twc/widgets/base_screen.dart';
import 'package:twc/widgets/common_text_field.dart';
import 'package:twc/widgets/widget_snacbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sectorController = TextEditingController();
  bool isLoading = false;

  void saveDataLogin({
    required String token,
    required String role,
    required int id,
  }) async {
    PreferencesHelper preferencesHelper =
        PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());
    preferencesHelper.setStringSharedPref('token', token);
    preferencesHelper.setStringSharedPref("role", role);
    preferencesHelper.setIntSharedPref("id", id);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 80.h),
          _buildFormLogin(),
        ],
      ),
    );
  }

  Widget _buildFormLogin() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 60.w),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Login",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10.h),
            CommonInputFieldWithLabel(
              label: "Nama Pegawai",
              hint: "Isi Nama Lengkap",
              controller: _nameController,
              hintStyle: _formStyle(),
              customTextStyle: _formStyle(),
            ),
            SizedBox(height: 10.h),
            CommonInputFieldWithLabel(
              label: "Sektor Kerja",
              hint: "Isi Sektor Kerja",
              controller: _sectorController,
              hintStyle: _formStyle(),
              customTextStyle: _formStyle(),
            ),
            SizedBox(height: 20.h),
            InkWell(
              onTap: () {
                PegawaiService()
                    .postUser(
                  onLoading: (value) {
                    setState(() {
                      isLoading = value;
                    });
                  },
                  name: _nameController.text,
                  sector: _sectorController.text,
                )
                    .then((value) {
                  if (value.status == 200) {
                    saveDataLogin(
                      token: value.data?.token ?? "",
                      role: value.data?.role ?? "",
                      id: value.data?.id ?? 0,
                    );
                    if (value.data?.role == "admin") {
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
                  } else {
                    WidgetSnackBar().showSnackBarError(
                      context: context,
                      title: "Error",
                      subtitle: "Nama dan Sektor Kerja Anda Salah",
                    );
                  }
                });
              },
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : _buildLabel(
                        colors: Colors.blueAccent,
                        text: "Login",
                        colorText: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 6.h,
                          horizontal: 30.w,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _formStyle() {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w800,
      color: Colors.black,
    );
  }

  Widget _buildLabel({
    required String text,
    required Color colors,
    Color? colorText,
    EdgeInsets? padding,
  }) {
    return Container(
      color: colors,
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 6.h,
          ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w800,
            color: colorText ?? Colors.black),
      ),
    );
  }
}
