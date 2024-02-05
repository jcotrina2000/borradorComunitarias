import 'package:dio/dio.dart';
import 'package:explorak5/api/courses_api.dart';
import 'package:explorak5/api/assignments_api.dart';
import 'package:explorak5/api/authentication_api.dart';
import 'package:explorak5/api/grades_api.dart';
import 'package:explorak5/api/modules_api.dart';
import 'package:explorak5/api/periods_api.dart';
import 'package:explorak5/api/school_logo_api.dart';
import 'package:explorak5/api/submissions_api.dart';
import 'package:explorak5/api/notification_api.dart';
import 'package:explorak5/api/user_api.dart';
import 'package:explorak5/helpers/http.dart';
import 'package:explorak5/helpers/http_constants.dart';
import 'package:explorak5/services/authentication_client.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:get/get.dart';
import '../api/courses_color_api.dart';
import '../api/pages_api.dart';
import '../services/network_status_service.dart';

abstract class DependecyInjection {
  static Future<void> initialize() async {
    final dio = Dio(BaseOptions(baseUrl: BASE_URL));
    Http http = Http(dio: dio);

    final authenticationAPI = AuthenticationAPI(http);
    GetIt.instance.registerSingleton<AuthenticationAPI>(authenticationAPI);

    Get.put<NetworkStatusService>(NetworkStatusService(), permanent: true);

    final secureStorage = FlutterSecureStorage();
    final authenticationClient =
        AuthenticationClient(secureStorage, authenticationAPI);
    GetIt.instance
        .registerSingleton<AuthenticationClient>(authenticationClient);

    final assignmentsAPI = AssignmentsAPI(http, authenticationClient);
    GetIt.instance.registerSingleton<AssignmentsAPI>(assignmentsAPI);

    final coursesAPI = CoursesAPI(http, authenticationClient);
    GetIt.instance.registerSingleton<CoursesAPI>(coursesAPI);

    final coursesColorsAPI = CoursesColorsAPI(http, authenticationClient);
    GetIt.instance.registerSingleton<CoursesColorsAPI>(coursesColorsAPI);

    final submissionsAPI = SubmissionsAPI(http, authenticationClient);
    GetIt.instance.registerSingleton<SubmissionsAPI>(submissionsAPI);

    final notificationsAPI = NotificationsAPI(http, authenticationClient);
    GetIt.instance.registerSingleton<NotificationsAPI>(notificationsAPI);

    final gradesAPI = GradesAPI(http, authenticationClient);
    GetIt.instance.registerSingleton<GradesAPI>(gradesAPI);

    final periodsAPI = PeriodsAPI(http, authenticationClient);
    GetIt.instance.registerSingleton<PeriodsAPI>(periodsAPI);

    final userAPI = UserAPI(http);
    GetIt.instance.registerSingleton<UserAPI>(userAPI);

    final moduleAPI = ModuleAPI(http, authenticationClient);
    GetIt.instance.registerSingleton<ModuleAPI>(moduleAPI);

    final pageAPI = PagesAPI(http, authenticationClient);
    GetIt.instance.registerSingleton<PagesAPI>(pageAPI);

    final schoolLogoAPI = SchoolLogoAPI(http, authenticationClient);
    GetIt.instance.registerSingleton<SchoolLogoAPI>(schoolLogoAPI);

    final localNotifications = FlutterLocalNotificationsPlugin();
    await localNotifications.initialize(InitializationSettings(
      android: AndroidInitializationSettings('launcher_icon'),
      iOS: IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      ),
    ));
    GetIt.instance
        .registerSingleton<FlutterLocalNotificationsPlugin>(localNotifications);
  }
}
