import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twc/models/list_laporan_pegawai_model.dart';
import 'package:twc/models/login_model.dart';
import 'package:twc/service/network_helper.dart';
import 'package:twc/service/preference_helper.dart';

class PegawaiService {
  static final NetworkHelper _dio = NetworkHelper();

  PreferencesHelper preferencesHelper =
      PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());

  Future<LoginModel> postUser({
    required Function(bool) onLoading,
    required String name,
    required String sector,
  }) async {
    try {
      onLoading(true);
      final map = <String, dynamic>{};
      map['name'] = name;
      map['sector'] = sector;
      var response = await _dio.post(
        "https://tamanwisatacandi.com/api/login",
        data: map,
      );

      if (response.statusCode == 200) {
        onLoading(false);
        return LoginModel.fromJson(
          response.data,
        );
      } else {
        onLoading(false);
        return LoginModel(
          status: 401,
          messages: "Gagal",
        );
      }
    } catch (e) {
      onLoading(false);
      throw Exception(e);
    }
  }

  Future<String> postImages({
    required XFile image,
    required Function(bool) onLoading,
  }) async {
    onLoading(true);
    try {
      var data = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          image.path,
          filename: DateTime.now().toString(),
        ),
      });
      var response = await _dio.post(
        'https://tamanwisatacandi.com/api/image/store',
        data: data,
      );
      onLoading(false);
      return response.data["data"]["image_id"].toString();
    } catch (e) {
      onLoading(false);
      throw Exception(e);
    }
  }

  Future<Response> postDataLaporanPegawai({
    required String description,
    required List<int> listPhotos,
  }) async {
    try {
      final map = <String, dynamic>{};
      map['description'] = description;
      map['image'] = "$listPhotos";
      var response = await _dio.post(
        'https://tamanwisatacandi.com/api/report/store',
        data: map,
      );
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<ListLaporanPegawaiModel> getListLaporanPegawai({
    required String idUser,
    String? sector,
  }) async {
    try {
      if (idUser == "") {
        var response = await _dio
            .get("https://tamanwisatacandi.com/api/report?sector=$sector");
        return ListLaporanPegawaiModel.fromJson(
          response.data,
        );
      } else {
        var response = await _dio
            .get("https://tamanwisatacandi.com/api/report?user_id=$idUser");
        return ListLaporanPegawaiModel.fromJson(
          response.data,
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
