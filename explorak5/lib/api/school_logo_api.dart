import 'package:explorak5/helpers/http.dart';
import 'package:explorak5/helpers/http_response.dart';
import 'package:explorak5/services/authentication_client.dart';

//clase con metodo para obtener logo de la escuela
class SchoolLogoAPI {
  final Http _http;
  final AuthenticationClient _authenticationClient;

  SchoolLogoAPI(this._http, this._authenticationClient);

  Future<HttpResponse> getSchoolLogo() async {
    final userData = await _authenticationClient.userData;
    return _http.request(
        'http://192.168.3.245/dist/brandable_css/3f77cad298c5859f8558daaf7aee273b/variables-7dd4b80918af0e0218ec0229e4bd5873.css',
        method: 'GET',
        headers: {"Authorization": "Bearer " + userData.token});
  }
}
