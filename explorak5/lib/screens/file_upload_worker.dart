import 'package:dio/dio.dart';
import 'package:explorak5/api/submissions_api.dart';
import 'package:explorak5/helpers/utils.dart';
import 'package:explorak5/models/assignment.dart';
import 'package:explorak5/services/authentication_client.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FileUploadWorker {
  final _authenticationClient = GetIt.instance<AuthenticationClient>();
  final _submissionsAPI = GetIt.instance<SubmissionsAPI>();
  final _localNotification = GetIt.instance<FlutterLocalNotificationsPlugin>();
  final _idg = new IntIDGenerator(initRandom: true);
  bool? done;
  List<dynamic> _fileIds = [];
  //dynamic _files;
  int _nFiles = 0;
  Assignment? assignment;

  // Usa los parametros recibidos del API de Canvas para subir los archivos y obtener un URL de validacion
  // Cuando se sube el archivo, el servidor responde con status REDIRECT 302
  // FlutterUploader hace el redirect automaticamente
  Future uploadFiles(
      List<dynamic> uploadParams, Assignment assignment, dynamic files) async {
    //this._files = files;
    this.assignment = assignment;
    _nFiles = uploadParams.length;

    for (final param in uploadParams) {
      if (param == null) return;
      int notificationId = _idg.next();
      try {
        void progressHandler(int sent, int total) {
          int progress = ((sent / total) * 100).floor();
          _showProgressNotification(
              notificationId, notificationId.toString(), progress);
        }

        final formData = FormData.fromMap({
          "key": param["response_data"]["upload_params"]["key"],
          "acl": param["response_data"]["upload_params"]["acl"],
          "Policy": param["response_data"]["upload_params"]["Policy"],
          "Filename": param["response_data"]["upload_params"]["Filename"],
          "Signature": param["response_data"]["upload_params"]["Signature"],
          "content-type": param["response_data"]["upload_params"]
              ["content-type"],
          "file": await MultipartFile.fromFile(param["file"].path,
              filename: param["file"].name)
        });

        final res = await _submissionsAPI.uploadFiles(
          param["response_data"]["upload_url"],
          formData,
          progressHandler,
        );

        if (res.data == null) {
          String fileURL = res.error.headers;
          final resFile = await _submissionsAPI.validateFiles(fileURL);
          if (resFile.data != null) {
            _fileIds.add(resFile.data["id"]);
          } else {
            await _clean(fromError: true);
            break;
          }
        } else {
          await _clean(fromError: true);
          break;
        }
      } catch (e) {
        await _clean(fromError: true);
        break;
      }
    }

    await _clean();
    if (_fileIds.length == _nFiles) {
      done = await _postSubmission(_fileIds);
      if (done!) {
        await _showDoneNotification(assignment.name);
      } else {
        await _clean(fromError: true);
      }
    } else {
      await _showErrorNotification(assignment.name);
    }
  }

  //Asocia archivo subido con entrega de tarea
  Future<bool> _postSubmission(List<dynamic> fileIds) async {
    FormData formData = FormData.fromMap({
      "submission[submission_type]": "online_upload",
      "submission[file_ids][]": fileIds
    });
    final response = await _submissionsAPI.submitAssignment(
        this.assignment!.courseId, this.assignment!.id, formData);
    if (response.data != null) {
      return true; // Tarea entregada
    } else {
      _deleteFiles(fileIds); // Tarea no entregada
      return false;
    }
  }

  void _deleteFiles(fileIds) async {
    for (var fileId in fileIds) {
      final response = await _submissionsAPI.deleteFiles(fileId);
      if (response.data != null) {
      } else {}
    }
  }

  Future _clean({bool fromError = false}) async {
    await _localNotification.cancelAll();
    if (fromError) {
      await _showErrorNotification(assignment!.name);
    }
  }

  Future<void> _showProgressNotification(
      int notificationId, String channelId, int progress) async {
    await _localNotification.show(
        notificationId,
        "Subiendo Archivo..",
        "$progress %",
        NotificationDetails(
            android: AndroidNotificationDetails(
          channelId,
          "channel name $channelId",
          'description',
          channelShowBadge: false,
          importance: Importance.max,
          priority: Priority.high,
          onlyAlertOnce: true,
          showProgress: true,
          maxProgress: 100,
          progress: progress,
        )));
  }

  Future<void> _showDoneNotification(String assignmentName) async {
    int id = _idg.nextRand();
    await _localNotification.show(
        id, // random id
        "Tarea enviada",
        "Se envió la tarea $assignmentName",
        NotificationDetails(
            android: AndroidNotificationDetails(
          "done$id",
          "channel name $id",
          'description',
          channelShowBadge: false,
          importance: Importance.max,
          priority: Priority.high,
          onlyAlertOnce: true,
        )));
  }

  Future<void> _showErrorNotification(String assignmentName) async {
    int id = _idg.nextRand();
    await _localNotification.show(
        id, // random id
        "Tarea NO enviada",
        "No se pudo enviar $assignmentName",
        NotificationDetails(
            android: AndroidNotificationDetails(
          "notDOne$id",
          "channel name $id",
          'description',
          channelShowBadge: false,
          importance: Importance.max,
          priority: Priority.high,
          onlyAlertOnce: true,
        )));
  }

  dynamic getHeader() async {
    final userData = await _authenticationClient.userData;
    return {"Authorization": "Bearer " + userData.token};
  }
}
