//import 'package:explorak5/api/modules_api.dart';
import 'package:explorak5/models/assignment.dart';
import 'package:explorak5/models/modules.dart';
import 'package:explorak5/services/notifications_client.dart';
import 'package:explorak5/services/storage_client.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/assignments_api.dart';
import '../api/courses_api.dart';
import '../api/notification_api.dart';
import '../api/submissions_api.dart';
import '../helpers/operators.dart';
import '../models/courses.dart';
import '../models/notificacion.dart';
import '../screens/assignment_provider.dart';
import '../screens/courses_provider.dart';

class AutoUpdate {
  static NotificationCLient service = NotificationCLient();
  static var _coursesAPI = GetIt.instance<CoursesAPI>();
  static var _submissionAPI = GetIt.instance<SubmissionsAPI>();
  static var _assignmentsAPI = GetIt.instance<AssignmentsAPI>();
  //static var _moduleAPI = GetIt.instance<ModuleAPI>();
  static var _notificationsAPI = GetIt.instance<NotificationsAPI>();

  static Future<void> getNotifications() async {
    service.intialize();
    print('autoupdate notification');
    SharedPreferences pref = await SharedPreferences.getInstance();
    for (Course course in CoursesProvider.availableCourses) {
      final response = await _notificationsAPI.getNotifications(course.id);
      if (response.data != null) {
        for (var notification in response.data) {
          Notificacion noti = Notificacion.fromJson(notification);
          if (!pref.containsKey(StorageClient.keyNoti) ||
              pref.getString(StorageClient.keyNoti) == null) {
            // first time writing notification in LS
            print('*** write first notification ***');
            await StorageClient.writeLocalNoti(noti);
            String payload = course.id.toString() + "," + noti.assignmentId;
            await service.showNotificationWithPayload(
                noti.id, noti.title, noti.body, payload);
          } else if (pref.getString(StorageClient.keyNoti) != null) {
            // not first time witing notification in LS
            String localNoti = pref.getString(StorageClient.keyNoti)!;
            List<Notificacion> listNoti = Notificacion.decode(localNoti);
            List<int> setId = [];
            for (var notifi in listNoti) {
              setId.add(notifi.id);
            }
            if (!setId.contains(noti.id)) {
              print('*** write new notification ***');
              await StorageClient.writeLocalNoti(noti);
              String payload = course.id.toString() + "," + noti.assignmentId;
              await service.showNotificationWithPayload(
                  noti.id, noti.title, noti.body, payload);
            }
          }
        }
      }
    }
  }

  Future<bool> getCourses() async {
    print('autoupdate course');
    Set<int> oldCourses = {};
    Set<int> newCourses = {};
    Course curso;
    for (var course in CoursesProvider.availableCourses) {
      oldCourses.add(course.id);
    }
    final response = await _coursesAPI.getCourses();
    if (response.data != null) {
      for (var course in response.data) {
        curso = Course.fromJson(course);
        if (curso.isPublic != false) {
          newCourses.add(curso.id);
        }
      }
      if (!(Operators.setEquals(oldCourses, newCourses))) {
        return true;
      }
    }
    return false;
  }

  static Future<bool> showPoint(Course course) async {
    print('autoupdate showpoint');
    bool valor = false;
    final response = await _assignmentsAPI.getAssignments(course.id);
    if (response.data != null) {
      for (var assignment in response.data) {
        List<dynamic> submissionTypes = assignment["submission_types"];
        if (!(assignment["is_quiz_assignment"]) &&
            submissionTypes.contains("online_upload")) {
          var submisionResponse = await _submissionAPI.getAssignment(
              assignment["id"], assignment["course_id"]);
          if (submisionResponse.data != null) {
            String workState = submisionResponse.data["workflow_state"] + '';
            assignment['workflow_state'] = workState;
            if (workState == "unsubmitted") {
              valor = true;
            } else {
              valor = false;
            }
          }
        }
      }
    }
    return valor;
  }

  Future<bool> getAssignments(Course course) async {
    print('autoupdate assignment');
    Set<int> oldAssignment = {};
    Set<int> newAssignmets = {};
    Assignment assign;
    for (var todo in AssignmentProvider.toDoList) {
      oldAssignment.add(todo.id);
    }
    for (var submitted in AssignmentProvider.submittedList) {
      oldAssignment.add(submitted.id);
    }
    final response = await _assignmentsAPI.getAssignments(course.id);
    if (response.data != null) {
      for (var assignment in response.data) {
        List<dynamic> submissionTypes = assignment["submission_types"];
        if (!(assignment["is_quiz_assignment"]) &&
            submissionTypes.contains("online_upload")) {
          assign = Assignment.fromJson(assignment);
          newAssignmets.add(assign.id);
        }
      }
      if (!(Operators.setEquals(oldAssignment, newAssignmets))) {
        return true;
      }
    }
    return false;
  }

  Future<bool> getModules(Course course) async {
    print("autUpdate module");
    Set<int> oldModules = {};
    Set<int> newModules = {};
    Modules module;
    for (var course in CoursesProvider.availableCourses) {
      oldModules.add(course.id);
    }
    final response = await _coursesAPI.getCourses();
    if (response.data != null) {
      for (var course in response.data) {
        module = Modules.fromJson(course);
        if (module.state == "active") {
          newModules.add(module.id);
        }
      }
      if (!(Operators.setEquals(oldModules, newModules))) {
        return true;
      }
    }
    return false;
  }
}
