import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twc/service/preference_helper.dart';
import 'package:twc/widgets/widget_snacbar.dart';

class NetworkHelper {
  static const String divider = "\n------------------------------------";
  static final Dio _dio = Dio();

  static String handleErr(context, Object e, {bool isShowAlert = false}) {
    String error = "";
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map) {
        error = data.entries.first.value;
      } else {
        error = e.message ?? "";
      }
    } else {
      error = e.toString();
    }
    if (isShowAlert) {
      WidgetSnackBar().showSnackBarError(
        context: context,
        title: "Error",
        subtitle: "Koneksi Anda Bermasalah",
      );
    }
    return error;
  }

  static dynamic handleRes(Response res) {
    final statusCode = res.statusCode ?? 0;
    if (statusCode >= 200 && statusCode < 400) return res.data;
    throw res;
  }

  // static final NetworkHelper _instance = NetworkHelper.internal();
  // NetworkHelper.internal();
  // factory NetworkHelper() => _instance;

  // final _dio = DioUtil.getInstance();

  static const _connectTimeoutDefault = Duration(seconds: 60);
  static const _receiveTimeoutDefault = Duration(seconds: 60);
  static const _sendTimeoutDefault = Duration(seconds: 60);

  //  final _d = client(isUseToken: true, connectTimeout: _connectTimeoutDefault, receiveTimeout: _receiveTimeoutDefault, sendTimeout: _sendTimeoutDefault);

  // String _formDataToJson(FormData formData) {
  //   final fields = formData.fields;
  //   final files = formData.files;
  //   final map = <String, String>{};

  //   for (MapEntry<String, String> field in fields) {
  //     map[field.key] = field.value;
  //   }

  //   for (MapEntry<String, MultipartFile> file in files) {
  //     map[file.key] = file.value.filename ?? '';
  //   }

  //   return json.encode(map);
  // }

  Future<Response> get(String endpoint,
      {bool isUseToken = true,
      Map<String, dynamic>? params,
      Function(int, int)? progress,
      Options? options}) async {
    PreferencesHelper preferencesHelper =
        PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());
    final dio = await client(isUseToken: isUseToken);

    log('token ${await preferencesHelper.getToken}');
    dio.options.headers['Authorization'] =
        '${await preferencesHelper.getToken}';
    return await dio.get(endpoint,
        queryParameters: params, onReceiveProgress: progress, options: options);
  }

  Future<Response> post(String endpoint,
      {bool isUseToken = true,
      Map<String, dynamic>? params,
      Function(int, int)? receiveProgress,
      Function(int, int)? progress,
      Options? options,
      dynamic data}) async {
    PreferencesHelper preferencesHelper =
        PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());

    String token = await preferencesHelper.getToken;
    final dio = await client(isUseToken: isUseToken);
    log("token $token");

    dio.options.headers['Authorization'] = await preferencesHelper.getToken;
    return await dio.post(endpoint,
        queryParameters: params,
        onReceiveProgress: receiveProgress,
        options: options,
        onSendProgress: progress,
        data: data);
  }

  Future<Response> postFormData(String endpoint,
      {bool isUseToken = true,
      Map<String, dynamic>? params,
      Function(int, int)? receiveProgress,
      Function(int, int)? progress,
      Options? options,
      dynamic data}) async {
    PreferencesHelper preferencesHelper =
        PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());

    String token = await preferencesHelper.getToken;
    log("token $token");
    _dio.options.headers['Authorization'] = '$token';
    _dio.options.headers['Content-Type'] = 'multipart/form-data';
    return await _dio.post(endpoint,
        queryParameters: params,
        onReceiveProgress: receiveProgress,
        options: options,
        onSendProgress: progress,
        data: data);
  }

  Future<Response> put(String endpoint,
      {bool isUseToken = true,
      Map<String, dynamic>? params,
      Function(int, int)? receiveProgress,
      Function(int, int)? progress,
      Options? options,
      dynamic data}) async {
    PreferencesHelper preferencesHelper =
        PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());

    _dio.options.headers['Authorization'] =
        '${await preferencesHelper.getToken}';
    return await _dio.put(endpoint,
        queryParameters: params,
        onReceiveProgress: receiveProgress,
        onSendProgress: progress,
        options: options,
        data: data);
  }

  Future<Response> patch(String endpoint,
      {bool isUseToken = true,
      Map<String, dynamic>? params,
      Function(int, int)? receiveProgress,
      Function(int, int)? progress,
      Options? options,
      dynamic data}) async {
    PreferencesHelper preferencesHelper =
        PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());

    _dio.options.headers['Authorization'] =
        '${await preferencesHelper.getToken}';
    return await _dio.patch(endpoint,
        queryParameters: params,
        onReceiveProgress: receiveProgress,
        onSendProgress: progress,
        options: options,
        data: data);
  }

  Future<Response> delete(String endpoint,
      {bool isUseToken = true,
      Map<String, dynamic>? params,
      Options? options,
      dynamic data}) async {
    PreferencesHelper preferencesHelper =
        PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());

    _dio.options.headers['Authorization'] =
        '${await preferencesHelper.getToken}';
    return await _dio.delete(endpoint,
        queryParameters: params, options: options, data: data);
  }

  Future<Response> download(String endpoint,
      {bool isUseToken = true,
      savePath,
      dynamic data,
      Options? options,
      Function(int, int)? progress,
      Map<String, dynamic>? params}) async {
    PreferencesHelper preferencesHelper =
        PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());

    _dio.options.headers['Authorization'] =
        '${await preferencesHelper.getToken}';
    return await _dio.download(endpoint, savePath,
        data: data,
        options: options,
        onReceiveProgress: progress,
        queryParameters: params);
  }

  Future<Dio> client(
      {isUseToken = true,
      Duration? connectTimeout,
      Duration? receiveTimeout,
      Duration? sendTimeout}) async {
    // final client = Dio();
    PreferencesHelper preferencesHelper =
        PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());
    String token;
    if (isUseToken) {
      token = await preferencesHelper.getToken;
    } else {
      token = '';
    }
    _dio.interceptors.add(interceptor(token,
        connectTimeout: connectTimeout ?? _connectTimeoutDefault,
        receiveTimeout: receiveTimeout ?? _receiveTimeoutDefault,
        sendTimeout: sendTimeout ?? _sendTimeoutDefault));
    return _dio;
  }

  InterceptorsWrapper interceptor(String token,
      {Duration connectTimeout = _connectTimeoutDefault,
      Duration receiveTimeout = _receiveTimeoutDefault,
      Duration sendTimeout = _sendTimeoutDefault}) {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        log('message request ${options.data}');

        // String? token = await StorageService().readAccessToken();
        // options.headers['Authorization'] = '$token';
        return handler.next(options);
      },
      onResponse: (options, handler) {
        log('message response ${options.requestOptions.path} : ${jsonEncode(options.data)}');

        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        log('message ${e.response?.statusCode.toString()}');
        if (e.response != null) {
          final PreferencesHelper preferencesHelper = PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance());
          if (e.response?.statusCode == 401) {
            preferencesHelper.removeStringSharedPref("token");
          }
          return handler.next(e);
        }
      },
    );
  }
}
