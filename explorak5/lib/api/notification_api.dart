import 'package:explorak5/helpers/http.dart';
import 'package:explorak5/helpers/http_response.dart';
import 'package:explorak5/services/authentication_client.dart';

class NotificationsAPI {
  final Http _http;
  final AuthenticationClient _authenticationClient;

  NotificationsAPI(this._http, this._authenticationClient);

  Future<HttpResponse> getNotifications(int courseId) async {
    final userData = await _authenticationClient.userData;
    return _http.request('/api/v1/courses/$courseId/activity_stream',
        method: 'GET', headers: {"Authorization": "Bearer " + userData.token});
  }
}
