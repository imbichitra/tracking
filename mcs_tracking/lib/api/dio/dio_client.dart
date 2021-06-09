import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:mcs_tracking/api/constant.dart';
import 'package:mcs_tracking/utils/dio_logging_interceptors.dart';


class DioClient {
  static Dio _dio;
  static getInstance() {
    if (_dio == null) {
      _dio = new Dio();
      _dio.options.baseUrl = BASE_URL;
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
      _dio.interceptors.add(DioLoggingInterceptors(_dio));
    }
    return _dio;
  }
}
