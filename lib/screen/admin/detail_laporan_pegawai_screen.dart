import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:twc/models/list_laporan_pegawai_model.dart';
import 'package:twc/service/admin_service.dart';
import 'package:twc/widgets/base_screen.dart';

class DetailLaporanPegawaiScreen extends StatefulWidget {
  final Data? data;

  const DetailLaporanPegawaiScreen({
    super.key,
    this.data,
  });

  @override
  State<DetailLaporanPegawaiScreen> createState() =>
      _DetailLaporanPegawaiScreenState();
}

class _DetailLaporanPegawaiScreenState
    extends State<DetailLaporanPegawaiScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      text: "Hasil Laporan Pegawai",
      body: Column(
        children: [
          SizedBox(height: 10.h),
          Container(
            width: 200.w,
            height: 200.w,
            color: Colors.white,
            child: (widget.data?.image?.isEmpty ?? false)
                ? SizedBox(
                    height: 100.w,
                    width: 150.w,
                  )
                : Image.network(
                    "https://tamanwisatacandi.com/public/images/report/images/${widget.data?.image?[0].image}",
                    height: 200.w,
                    width: 200.w,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (ctx, object, trace) {
                      return SizedBox(
                        height: 200.w,
                        width: 200.w,
                      );
                    },
                  ),
          ),
          SizedBox(height: 10.h),
          _buildLabel(
            text: widget.data?.name ?? "",
            colors: Colors.white,
          ),
          SizedBox(height: 10.h),
          _buildLabel(
            text: widget.data?.sector ?? "",
            colors: Colors.white,
          ),
          SizedBox(height: 10.h),
          _buildLabel(
            text: widget.data!.description ?? "",
            colors: Colors.white,
          ),
          SizedBox(height: 10.h),
          InkWell(
            onTap: () {
              AdminService()
                  .deleteLaporanPegawai(
                id: widget.data?.id.toString() ?? "",
                onLoading: (value) {
                  setState(() {
                    isLoading = value;
                  });
                },
              )
                  .then((value) {
                if (value.statusCode == 200 || value.statusCode == 201) {
                  Navigator.pop(context, true);
                }
              });
            },
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _buildLabel(
                    text: "delete data pegawai",
                    colors: Colors.red,
                    colorText: Colors.white,
                  ),
          ),
        ],
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
      width: 200.w,
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: 6.h,
          ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w800,
            color: colorText ?? Colors.black,
          ),
        ),
      ),
    );
  }
}
