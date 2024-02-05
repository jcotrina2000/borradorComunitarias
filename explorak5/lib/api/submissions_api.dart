import 'package:explorak5/helpers/http.dart';
import 'package:explorak5/helpers/http_response.dart';
import 'package:explorak5/services/authentication_client.dart';

//Clase con metodos para la subida de archivos y entrega de tareas
class SubmissionsAPI {
  final Http _http;
  final AuthenticationClient _authenticationClient;

  SubmissionsAPI(this._http, this._authenticationClient);

  //Obtener parámetros de Canvas para subir un archivo
  Future<HttpResponse> getUploadParams(dynamic data) async {
    final userData = await _authenticationClient.userData;
    return _http.request('/api/v1/users/self/files',
        method: 'POST',
        data: data,
        headers: {"Authorization": "Bearer " + userData.token});
  }

  //Enviar un archivo a servidor de Canvas usando parámetros obtenidos
  Future<HttpResponse> uploadFiles(String uploadUrl, dynamic data,
      Function(int sent, int total) onSendProgress) async {
    final userData = await _authenticationClient.userData;
    return _http.request(uploadUrl,
        method: 'POST',
        data: data,
        headers: {"Authorization": "Bearer " + userData.token},
        onSendProgress: onSendProgress);
  }

  //Validar URL de archivo subido para que sea visible
  Future<HttpResponse> validateFiles(String fileUrl) {
    return _http.request(fileUrl, method: 'GET');
  }

  //Entregar una tarea asociandole archivos subidos
  Future<HttpResponse> submitAssignment(
      int courseId, int assignmentId, dynamic data) async {
    final userData = await _authenticationClient.userData;
    return _http.request(
        '/api/v1/courses/$courseId/assignments/$assignmentId/submissions',
        method: 'POST',
        data: data,
        headers: {"Authorization": "Bearer " + userData.token});
  }

  //Eliminar archivos subidos en caso de que la entrega no sea exitosa
  Future<HttpResponse> deleteFiles(int fileId) async {
    final userData = await _authenticationClient.userData;
    return _http.request('/api/v1/files/$fileId',
        method: 'DELETE',
        headers: {"Authorization": "Bearer " + userData.token});
  }

  // obtener un especifico submission con la assignsment["id"] y el assignsment["course_id"]
  Future<HttpResponse> getAssignment(int assignmentId, int courseId) async {
    final userData = await _authenticationClient.userData;
    return _http.request(
        '/api/v1/courses/$courseId/assignments/$assignmentId/submissions/self',
        method: 'GET',
        headers: {"Authorization": "Bearer " + userData.token});
  }
}
