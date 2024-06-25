import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class WidgetSnackBar {
  void showSnackBarError({
    required BuildContext context,
    required String title,
    required String subtitle,
  }) {
    Flushbar(
      title: title,
      message: subtitle,
      titleColor: Colors.white,
      messageColor: Colors.white,
      backgroundColor: Colors.red,
      // icon: SvgPicture.asset(
      //   IceAssets.iceImageWarning,
      //   height: ScreenConfig.sixteenFontSize,
      //   width: ScreenConfig.sixteenFontSize,
      // ),
      icon: const Icon(
        Icons.warning,
        color: Colors.red,
      ),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      duration: const Duration(seconds: 4),
      borderRadius: BorderRadius.circular(8),
      margin: const EdgeInsets.all(8),
    ).show(context);
  }

  void showSnackBarSuccess({
    required BuildContext context,
    required String title,
    Widget? mainButton,
  }) {
    Flushbar(
      messageText: Text(
        title,
      ),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      messageColor: Colors.grey,
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.green,
      // icon: SvgPicture.asset(
      //   IceAssets.iceImageCheckCircle,
      //   height: ScreenConfig.sixteenFontSize,
      //   width: ScreenConfig.sixteenFontSize,
      // ),

      icon: const Icon(
        Icons.check_circle,
        color: Colors.green,
      ),
      mainButton: mainButton,
    ).show(context);
  }
}
