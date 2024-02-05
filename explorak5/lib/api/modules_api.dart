import 'package:explorak5/helpers/http.dart';
import 'package:explorak5/helpers/http_response.dart';
import 'package:explorak5/services/authentication_client.dart';

//clase con metodo para obtener cursos activos del estudiante
class ModuleAPI {
  final Http _http;
  final AuthenticationClient _authenticationClient;

  ModuleAPI(this._http, this._authenticationClient);

  Future<HttpResponse> getModules(int courseId) async {
    final userData = await _authenticationClient.userData;
    return _http.request('/api/v1/courses/$courseId/modules',
        method: 'GET', headers: {"Authorization": "Bearer " + userData.token});
  }
}
