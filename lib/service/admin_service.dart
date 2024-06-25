import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twc/models/user_model.dart';
import 'package:twc/service/network_helper.dart';
import 'package:twc/service/preference_helper.dart';

class AdminService {
  static final NetworkHelper _dio = NetworkHelper();

  PreferencesHelper preferencesHelper =
      PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());

  Future<Response> postAddDataPegawai({
    required String name,
    required String sector,
    required String number,
    required bool isEdit,
    String id = "",
  }) async {
    try {
      final map = <String, dynamic>{};
      map['name'] = name;
      map['sector'] = sector;
      map['number'] = number;
      if (isEdit == false) {
        map['role'] = "user";
      }
      if (isEdit == true) {
        map['id'] = id;
      }
      if (isEdit == true) {
        var response = await _dio.post(
          'https://tamanwisatacandi.com/api/user/update',
          data: map,
        );
        return response;
      } else {
        var response = await _dio.post(
          'https://tamanwisatacandi.com/api/user/store',
          data: map,
        );
        return response;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Response> deleteLaporanPegawai({
    required String id,
    required Function(bool) onLoading,
  }) async {
    try {
      onLoading(true);
      final map = <String, dynamic>{};
      map['id'] = id;
      var response = await _dio.post(
        'https://tamanwisatacandi.com/api/report/delete',
        data: map,
      );
      onLoading(false);
      return response;
    } catch (e) {
      onLoading(false);
      throw Exception(e);
    }
  }

  Future<UserModel> getListUser({
    required Function(bool) onLoading,
  }) async {
    try {
      onLoading(true);
      var response = await _dio.get("https://tamanwisatacandi.com/api/user");
      if (response.statusCode == 200) {
        onLoading(false);
      }
      return UserModel.fromJson(
        response.data,
      );
    } catch (e) {
      onLoading(false);
      throw Exception(e);
    }
  }
}
