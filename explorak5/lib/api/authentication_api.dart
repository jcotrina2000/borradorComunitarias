import 'package:explorak5/helpers/http.dart';
import 'package:explorak5/helpers/http_constants.dart';
import 'package:explorak5/helpers/http_response.dart';

//clase con metodo para obtener token de acceso y refrescar token
class AuthenticationAPI {
  final Http _http;

  AuthenticationAPI(this._http);

  Future<HttpResponse> getToken(dynamic data) {
    return _http.request(TOKEN_URL, method: 'POST', data: data);
  }

  Future<HttpResponse> refreshToken(dynamic data) {
    return _http.request(TOKEN_URL, method: 'POST', data: data);
  }

  Future<HttpResponse> deleteToken(token) {
    return _http.request(TOKEN_URL,
        method: 'DELETE', headers: {"Authorization": "Bearer " + token});
  }
}
