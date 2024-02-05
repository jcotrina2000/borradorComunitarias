import 'package:explorak5/helpers/http.dart';
import 'package:explorak5/helpers/http_response.dart';
import 'package:explorak5/services/authentication_client.dart';

//clase con metodo para obtener tareas activas del estudiante
class AssignmentsAPI {
  final Http _http;
  final AuthenticationClient _authenticationClient;

  AssignmentsAPI(this._http, this._authenticationClient);

  Future<HttpResponse> getAssignments(int courseId) async {
    final userData = await _authenticationClient.userData;
    return _http.request('/api/v1/courses/$courseId/assignments/',
        method: 'GET', headers: {"Authorization": "Bearer " + userData.token});
  }

  String getAssignmentImg(int assignmentId) {
    String id = assignmentId.toString();
    String path =
        'http://192.168.3.245/uploads/assignment/background/$id/background.jpeg';
    return path;
  }
}
