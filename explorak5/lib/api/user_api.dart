import 'package:explorak5/helpers/http.dart';
import 'package:explorak5/helpers/http_response.dart';

//clase con metodo para obtener información común del estudiante
class UserAPI {
  final Http _http;

  UserAPI(this._http);

  Future<HttpResponse> getUserData(String token) async {
    return _http.request('/api/v1/users/self',
        method: 'GET', headers: {"Authorization": "Bearer " + token});
  }
}
