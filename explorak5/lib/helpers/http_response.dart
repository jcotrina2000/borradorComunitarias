class HttpResponse {
  final dynamic data;
  final HttpError error;

  HttpResponse(this.data, this.error);

  static HttpResponse success(dynamic data) => HttpResponse(data, HttpError(statusCode: 200, message: "Success"));

  static HttpResponse fail(
          {required int statusCode, required String message, dynamic data, dynamic headers}) =>
      HttpResponse(
          null,
          HttpError(
              headers: headers,
              statusCode: statusCode,
              message: message,
              data: data));
}

class HttpError {
  final int statusCode;
  final String message;
  final dynamic data;
  final dynamic headers;

  HttpError({required this.statusCode, required this.message, this.data, this.headers});
}
