import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twc/screen/login_screen.dart';
import 'package:twc/screen/pegawai/list_laporan_pegawai.dart';
import 'package:twc/service/pegawai_service.dart';
import 'package:twc/service/preference_helper.dart';
import 'package:twc/widgets/base_screen.dart';
import 'package:twc/widgets/bottom_sheet_container.dart';
import 'package:twc/widgets/common_text_field.dart';
import 'package:twc/widgets/widget_snacbar.dart';

class LaporanPegawai extends StatefulWidget {
  const LaporanPegawai({Key? key}) : super(key: key);

  @override
  State<LaporanPegawai> createState() => _LoparanPegawaiState();
}

class _LoparanPegawaiState extends State<LaporanPegawai> {
  bool isLoadingUploadedPhotos = false;
  final List<int> listImage = [];
  final String urlImages = "";
  final TextEditingController _descController = TextEditingController();
  XFile? temporaryImage;
  bool isCompletedData = false;
  bool isLoadingUploadData = false;

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      text: "Laporan Pegawai",
      body: Padding(
        padding: EdgeInsets.only(
          left: 10.w,
          top: 20.h,
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                final XFile? image;

                final isCamera =
                    await BottomSheetContainer.showBottomSheet<bool>(
                  context,
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8 * 3),
                            child: Material(
                              child: InkWell(
                                // splashRadius: 8,
                                onTap: () {
                                  Navigator.pop(context, true);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8 * 5),
                                  child: const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.camera_alt_rounded,
                                        size: 40,
                                      ),
                                      Text("kamera")
                                    ],
                                  ),
                                ),
                                // child: const Text("Camera"),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8 * 3),
                            child: Material(
                              child: InkWell(
                                // splashRadius: 8,
                                onTap: () {
                                  Navigator.pop(context, false);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8 * 5),
                                  child: const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.photo_library_rounded,
                                        size: 40,
                                      ),
                                      Text("Galeri")
                                    ],
                                  ),
                                ),
                                // child: const Text("Camera"),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );

                if (isCamera == null) return;
                image = await ImagePicker().pickImage(
                  source: isCamera ? ImageSource.camera : ImageSource.gallery,
                );
                if (image != null) {
                  //post images

                  setState(() {
                    isLoadingUploadedPhotos = true;
                  });
                  PegawaiService()
                      .postImages(
                          image: image,
                          onLoading: (value) {
                            setState(() {
                              isLoadingUploadedPhotos = value;
                            });
                          })
                      .then((value) {
                    setState(() {
                      listImage.clear();
                      listImage.add(int.parse(value));
                      temporaryImage = image;
                      _checkDataCompleted();
                    });
                  });
                }
              },
              child: (temporaryImage != null)
                  ? Image.file(
                      File(temporaryImage?.path ?? ""),
                      height: 200.w,
                      width: 200.w,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 200.w,
                      width: 200.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          isLoadingUploadedPhotos
                              ? const CircularProgressIndicator()
                              : Icon(
                                  Icons.add,
                                  color: Colors.black,
                                  size: 40.sp,
                                  weight: 2,
                                ),
                          Text(
                            "Tambah Foto",
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 60.w,
                vertical: 20.h,
              ),
              child: CommonInputFieldWithLabel(
                hint: "Deskripsi Pekerjaan",
                controller: _descController,
                hintStyle: _formStyle(),
                customTextStyle: _formStyle(),
                onChanged: (value) {
                  _checkDataCompleted();
                },
                onEditingComplete: () {
                  _checkDataCompleted();
                },
              ),
            ),
            InkWell(
              onTap: () {
                if (isCompletedData == false) {
                  WidgetSnackBar().showSnackBarError(
                    context: context,
                    title: "Error",
                    subtitle: "Pastikan Image dan Description Terisi",
                  );
                } else {
                  setState(() {
                    isLoadingUploadData = true;
                  });
                  PegawaiService()
                      .postDataLaporanPegawai(
                    description: _descController.text,
                    listPhotos: listImage,
                  )
                      .then((value) {
                    setState(() {
                      isLoadingUploadData = false;
                    });
                    if (value.statusCode == 200) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ListLaporanPegawai(
                            isGetAll: false,
                          ),
                        ),
                      ).then((value) {
                        setState(() {
                          temporaryImage = null;

                          _descController.clear();
                          isCompletedData = false;
                        });
                      });
                    }
                  });
                }
              },
              child: Center(
                child: isLoadingUploadData
                    ? const CircularProgressIndicator()
                    : _buildLabel(
                        colors: Colors.blueAccent,
                        text: "Kirim",
                        colorText: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 6.h,
                          horizontal: 30.w,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 10.h),
            InkWell(
              onTap: () {
                removeAllDataPreference().then(
                  (value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                );
              },
              child: Center(
                child: _buildLabel(
                  colors: Colors.red,
                  text: "Log Out",
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

  Future<void> removeAllDataPreference() async {
    PreferencesHelper preferencesHelper =
        PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());
    preferencesHelper.removeStringSharedPref('token');
    preferencesHelper.removeStringSharedPref("role");
    preferencesHelper.removeStringSharedPref("id");
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

  void _checkDataCompleted() {
    setState(() {
      if (listImage.isNotEmpty && _descController.text.isNotEmpty) {
        isCompletedData = true;
      }
    });
  }

  TextStyle _formStyle() {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w800,
      color: Colors.black,
    );
  }
}
