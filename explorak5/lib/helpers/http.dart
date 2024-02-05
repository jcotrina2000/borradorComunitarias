import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import './http_response.dart';

class Http {
  Dio dio;

  Http({required this.dio});

  Future<HttpResponse> request(
    String path, {
    String method = "GET",
    String contentType = "application/json",
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, String>? headers,
    Function(int sent, int total)? onSendProgress,
  }) async {
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return client;
    };
    try {
      final response = await dio.request(path,
          options: Options(
              method: method, headers: headers, contentType: contentType),
          queryParameters: queryParameters,
          data: data,
          onSendProgress: onSendProgress);
      return HttpResponse.success(response.data);
    } catch (e) {
      int statusCode = -1;
      String message = "unknown error";
      dynamic data;
      dynamic headers;
      if (e is DioError) {
        message = e.message!;
        if (e.response != null) {
          statusCode = e.response!.statusCode!;
          message = e.response!.statusMessage!;
          data = e.response!.data!;
          headers = e.response!.headers.value("location");
        }
      }
      if (statusCode != 302) {
        print("Dio HTTP Request Error: $e");
      }
      return HttpResponse.fail(
          headers: headers,
          statusCode: statusCode,
          message: message,
          data: data);
    }
  }
}
