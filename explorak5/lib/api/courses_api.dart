import 'package:explorak5/helpers/http.dart';
import 'package:explorak5/helpers/http_response.dart';
import 'package:explorak5/services/authentication_client.dart';

//clase con metodo para obtener cursos activos del estudiante
class CoursesAPI {
  final Http _http;
  final AuthenticationClient _authenticationClient;

  CoursesAPI(this._http, this._authenticationClient);

  Future<HttpResponse> getCourses() async {
    final userData = await _authenticationClient.userData;
    print(userData.token);
    return _http.request('/api/v1/users/self/courses?include=course_image',
        method: 'GET', headers: {"Authorization": "Bearer " + userData.token});
  }

  Future<HttpResponse> getCourseId(String id) async {
    final userData = await _authenticationClient.userData;
    return _http.request('/api/v1/courses/$id',
        method: 'GET', headers: {"Authorization": "Bearer " + userData.token});
  }

  Future<HttpResponse> getCoursesTerms() async {
    final userData = await _authenticationClient.userData;
    return _http.request('/api/v1/users/self/courses?include=grading_periods',
        method: 'GET', headers: {"Authorization": "Bearer " + userData.token});
  }
}
