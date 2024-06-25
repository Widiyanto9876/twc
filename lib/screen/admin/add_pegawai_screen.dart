import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twc/screen/admin/list_user_screen.dart';
import 'package:twc/service/admin_service.dart';
import 'package:twc/widgets/base_screen.dart';
import 'package:twc/widgets/common_text_field.dart';
import 'package:twc/widgets/widget_snacbar.dart';

class AddPegawaiScreen extends StatefulWidget {
  final bool isFormEdit;
  final String name;
  final String sector;
  final String nomor;
  final String id;

  const AddPegawaiScreen({
    super.key,
    this.isFormEdit = false,
    this.name = "",
    this.sector = "",
    this.nomor = "",
    this.id = "",
  });

  @override
  State<AddPegawaiScreen> createState() => _AddPegawaiScreenState();
}

class _AddPegawaiScreenState extends State<AddPegawaiScreen> {
  final TextEditingController _nomorController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _sectorController = TextEditingController();
  bool isCompletedData = false;
  bool isLoading = false;

  @override
  void initState() {
    if (widget.isFormEdit == true) {
      _nomorController.text = widget.nomor;
      _nameController.text = widget.name;
      _sectorController.text = widget.sector;
      isCompletedData = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      text: "Tambah Data Pegawai",
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.w),
        child: Column(
          children: [
            SizedBox(height: 50.h),
            CommonInputFieldWithLabel(
              hint: "Input Nomer Pegawai",
              controller: _nomorController,
              hintStyle: _formStyle(),
              customTextStyle: _formStyle(),
              onChanged: (value) {
                _checkDataComplate();
              },
            ),
            SizedBox(height: 50.h),
            CommonInputFieldWithLabel(
              hint: "Input Nama Pegawai",
              controller: _nameController,
              hintStyle: _formStyle(),
              customTextStyle: _formStyle(),
              onChanged: (value) {
                _checkDataComplate();
              },
            ),
            SizedBox(height: 50.h),
            CommonInputFieldWithLabel(
              hint: "Input Sektor Pegawai",
              controller: _sectorController,
              hintStyle: _formStyle(),
              customTextStyle: _formStyle(),
              onChanged: (value) {
                _checkDataComplate();
              },
            ),
            SizedBox(height: 50.h),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : InkWell(
                    onTap: () {
                      print("cek data ${widget.isFormEdit}");
                      if (isCompletedData == false) {
                        WidgetSnackBar().showSnackBarError(
                          context: context,
                          title: "Error",
                          subtitle: "Pastikan Nomor,Nama dan Sektor Ke Isi",
                        );
                      } else {
                        setState(() {
                          isLoading = true;
                        });
                        AdminService()
                            .postAddDataPegawai(
                          name: _nameController.text,
                          sector: _sectorController.text,
                          number: _nomorController.text,
                          isEdit: widget.isFormEdit,
                          id: widget.id,
                        )
                            .then((value) {
                          if (value.statusCode == 200) {
                            setState(() {
                              isLoading = false;
                            });
                            if (widget.isFormEdit) {
                              Navigator.pop(context, true);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ListUserScreen(),
                                ),
                              ).then((value) {
                                _nomorController.clear();
                                _sectorController.clear();
                                _nameController.clear();
                              });
                            }
                          }
                        });
                      }
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
                          "Selesai",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  void _checkDataComplate() {
    setState(() {
      if (_nameController.text != "" &&
          _sectorController.text != "" &&
          _nomorController.text != "") {
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
