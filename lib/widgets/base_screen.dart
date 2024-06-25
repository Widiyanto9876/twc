import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseScreen extends StatelessWidget {
  BaseScreen({
    super.key,
    required this.body,
    this.text,
    this.ontap,
  });
  final Widget body;
  final String? text;
  Function? ontap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF838383),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 60.h),
              InkWell(
                onTap: () {
                  ontap?.call();
                },
                child: Image.asset(
                  "assets/twc_logo.png",
                  width: 200.w,
                  height: 80.h,
                  fit: BoxFit.fitHeight,
                ),
              ),
              SizedBox(height: 20.h),
              _buildLabel(
                colors: Colors.white,
                text: text ?? "Aplikasi Monitoring Pegawai",
              ),
              body,
            ],
          ),
        ),
      ),
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
