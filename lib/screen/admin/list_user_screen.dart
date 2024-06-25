import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twc/models/user_model.dart';
import 'package:twc/screen/admin/add_pegawai_screen.dart';
import 'package:twc/service/admin_service.dart';
import 'package:twc/widgets/base_screen.dart';

class ListUserScreen extends StatefulWidget {
  final bool isFormEditDataPegawai;

  const ListUserScreen({
    super.key,
    this.isFormEditDataPegawai = false,
  });

  @override
  State<ListUserScreen> createState() => _ListUserScreenState();
}

class _ListUserScreenState extends State<ListUserScreen> {
  UserModel userModel = UserModel();
  bool isLoading = false;

  @override
  void initState() {
    getListUser();
    super.initState();
  }

  void getListUser() {
    AdminService().getListUser(
      onLoading: (value) {
        setState(() {
          isLoading = value;
        });
      },
    ).then((value) {
      setState(() {
        userModel = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      text: "Data Karyawan",
      body: Column(
        children: [
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: userModel.data?.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        if (widget.isFormEditDataPegawai == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddPegawaiScreen(
                                isFormEdit: widget.isFormEditDataPegawai,
                                name: userModel.data?[index].name ?? "",
                                sector: userModel.data?[index].sector ?? "",
                                nomor: userModel.data?[index].number ?? "",
                                id: userModel.data?[index].id.toString() ?? "",
                              ),
                            ),
                          ).then((value) {
                            if (value == true) {
                              getListUser();
                            }
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 4.h,
                          horizontal: 10.w,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Column(
                          children: [
                            _buildRow(
                              key: "Nama",
                              value: userModel.data?[index].name ?? "",
                            ),
                            _buildRow(
                              key: "Sektor",
                              value: userModel.data?[index].sector ?? "",
                            ),
                            _buildRow(
                              key: "Role",
                              value: userModel.data?[index].role ?? "",
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required String key,
    required String value,
  }) {
    return Row(
      children: [
        Text(
          "$key : ",
          style: _formStyle(),
        ),
        SizedBox(width: 4.w),
        Text(
          value,
          style: _formStyle(),
        ),
      ],
    );
  }

  TextStyle _formStyle() {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w800,
      color: Colors.black,
    );
  }
}
