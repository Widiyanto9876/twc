import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twc/models/list_sector_model.dart';
import 'package:twc/screen/pegawai/list_laporan_pegawai.dart';
import 'package:twc/service/admin_service.dart';
import 'package:twc/widgets/base_screen.dart';

class ListSectorScreen extends StatefulWidget {
  const ListSectorScreen({super.key});

  @override
  State<ListSectorScreen> createState() => _ListSectorScreenState();
}

class _ListSectorScreenState extends State<ListSectorScreen> {
  bool isLoading = false;
  ListSectorModel data = ListSectorModel();

  @override
  void initState() {
    AdminService().getListSector(onLoading: (value) {
      setState(() {
        isLoading = value;
      });
    }).then(
      (dataList) {
        data = dataList;
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      text: "List Sektor",
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: data.data?.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListLaporanPegawai(
                          isGetAll: true,
                          sector: data.data?[index].sector,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 200.w,
                    height: 30.h,
                    margin: EdgeInsets.only(
                      bottom: 10.h,
                      right: 20.w,
                      left: 20.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      border: Border.all(
                        color: Colors.black,
                        width: 1.w,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        data.data?[index].sector ?? "",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
