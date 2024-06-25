import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twc/models/list_laporan_pegawai_model.dart';
import 'package:twc/screen/admin/detail_laporan_pegawai_screen.dart';
import 'package:twc/service/pegawai_service.dart';
import 'package:twc/service/preference_helper.dart';
import 'package:twc/widgets/base_screen.dart';

class ListLaporanPegawai extends StatefulWidget {
  final bool isGetAll;

  const ListLaporanPegawai({Key? key, required this.isGetAll})
      : super(key: key);

  @override
  State<ListLaporanPegawai> createState() => _ListLaporanPegawaiState();
}

class _ListLaporanPegawaiState extends State<ListLaporanPegawai> {
  ListLaporanPegawaiModel listLaporanPegawaiModel = ListLaporanPegawaiModel();
  bool isLoading = false;

  PreferencesHelper preferencesHelper =
      PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());
  int id = 1;

  void getId() async {
    id = await preferencesHelper.getId;
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });

    getId();
    Future.delayed(
      Duration(microseconds: 500),
      () {
        getDataList();
      },
    );
    super.initState();
  }

  void getDataList() {
    PegawaiService()
        .getListLaporanPegawai(
      idUser: widget.isGetAll ? "" : id.toString(),
    )
        .then((value) {
      setState(() {
        listLaporanPegawaiModel = value;
        isLoading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      text: "Laporan Kegiatan",
      ontap: () {
        print("cek data id $id");
      },
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1 / 0.92,
                mainAxisSpacing: 10.w,
                crossAxisSpacing: 10.w,
                crossAxisCount: 2,
              ),
              itemCount: listLaporanPegawaiModel.data?.length,
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 10.w,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (widget.isGetAll) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailLaporanPegawaiScreen(
                            data: listLaporanPegawaiModel.data?[index],
                          ),
                        ),
                      ).then((value) {
                        print("cek data $value");
                        if (value == true) {
                          getDataList();
                        }
                      });
                    }
                  },
                  child: Container(
                    width: 150.w,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        (listLaporanPegawaiModel.data?[index].image?.isEmpty ??
                                false)
                            ? SizedBox(
                                height: 100.w,
                                width: 150.w,
                              )
                            : Image.network(
                                "https://tamanwisatacandi.com/public/images/report/images/${listLaporanPegawaiModel.data?[index].image?[0].image}",
                                height: 100.w,
                                width: 150.w,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return SizedBox(
                                    height: 100.w,
                                    width: 150.w,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, object, trace) {
                                  return SizedBox(
                                    height: 100.w,
                                    width: 150.w,
                                  );
                                },
                              ),
                        Container(
                          height: 50.w,
                          width: double.infinity,
                          color: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(vertical: 6.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  listLaporanPegawaiModel.data?[index].name ??
                                      '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "${listLaporanPegawaiModel.data?[index].createdAt} ",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
