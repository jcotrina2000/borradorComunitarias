import 'package:dio/dio.dart';
import 'package:explorak5/models/assignment.dart';
import 'package:explorak5/api/submissions_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:explorak5/screens/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:explorak5/widgets/file_viewer_widget.dart';

import 'package:date_format/date_format.dart';
import 'package:explorak5/screens/base_screen.dart';
import 'package:flutter_html/flutter_html.dart';
//import 'package:progress_dialog/progress_dialog.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../exp_icons_icons.dart';
import '../models/courses.dart';
import '../services/authentication_client.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/side_menu_widget.dart';
import 'file_upload_worker.dart';

class AssignmentDescriptionScreen extends StatefulWidget {
  final Assignment assignment;
  final Course course;
  final Function(int assignmentId) onDone;

  AssignmentDescriptionScreen({
    required Key key,
    required this.assignment,
    required this.course,
    required this.onDone(int assignmentId),
  }) : super(key: key);

  @override
  _AssignmentDescriptionScreen createState() =>
      _AssignmentDescriptionScreen(assignment, course);
}

class _AssignmentDescriptionScreen extends State<AssignmentDescriptionScreen> {
  Assignment assignment;
  Course course;
  _AssignmentDescriptionScreen(this.assignment, this.course);

  String username = '';
  String materia = '';
  String avatar_url = DEFAULT_IMAGE;
  bool isLoading = false;
  final _authenticationClient = GetIt.instance<AuthenticationClient>();
  List<PlatformFile> _files = [];
  List<String> _paths = [];
  final _submissionsAPI = GetIt.instance<SubmissionsAPI>();


  @override
  void initState() {
    super.initState();
    _getUsername();
    materia = course.name;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Explora K5",
      theme: ThemeData(primaryColor: THEME_COLOR, fontFamily: 'Quicksand'),
      home: Scaffold(
        backgroundColor: Colors.white,
        drawer: SideMenu(),
        appBar: AppBarExplora(key: UniqueKey()),
        body: ListView(children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                  padding: PADDING_LARGE,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("$materia | Tareas", style: SCREEN_HEADER))),
              Padding(
                  padding: PADDING_LARGE,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        assignment.name,
                        style: SCREEN_MENU_HEADER,
                      ))),
              Padding(
                  padding: PADDING_LARGE,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Fecha de entrega: " + displayDate(assignment.dueAt),
                        style: SCREEN_MENU_HEADER,
                      ))),
              Padding(
                  padding: PADDING_LARGE,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Html(
                          data: assignment.description,
                          style: {
                            "body": Style(
                              fontSize: FontSize(18.0),
                              fontWeight: FontWeight.bold,
                            ),
                          },
                          onLinkTap: (url, _, __, ___) {
                            handleUrl(url!);
                          }))),
              Padding(
                  padding: PADDING_LARGE,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: _files.isEmpty
                          ? Text(
                              "Carga de archivos \nCargue un archivo o escoja un archivo ya cargado.",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal),
                            )
                          : (isLoading)
                              ? CircularProgressIndicator()
                              : Scrollbar(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                        _files.length,
                                      itemBuilder: (context, i) {
                                        final file = this._files[i];
                                        return FileView(
                                            file: file, removeFile: 5);
                                      })))),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: PALLETE_RED,
                    minimumSize: Size.fromHeight(40)),
                child:
                    Text("Selecionar archivo", style: FILE_PICKER_BUTTON_STYLE),
                onPressed: _pickFiles,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: 200,
                        child: ElevatedButton(
                            child: Text("Cancelar", style: CARD_BUTTON_STYLE),
                            onPressed: _handleClose)),
                    Container(
                        width: 200,
                        child: ElevatedButton(
                          child:
                              Text("Entregar tarea", style: CARD_BUTTON_STYLE),
                          onPressed: () {
                            _onSend(context);
                          },
                        ))
                  ]),
            ],
          )
        ]),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => BaseScreen(key: UniqueKey(), course: course),
              ));
            });
          },
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 35,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  ExpIcons.inicio,
                  color: PALLETE_BLUE,
                ),
                label: 'Inicio',
                activeIcon: CircleAvatar(
                    radius: 25,
                    backgroundColor: Color.fromARGB(165, 255, 255, 255),
                    child: Icon(
                      ExpIcons.inicio,
                      color: PALLETE_BLUE,
                      size: 40,
                    ))),
            BottomNavigationBarItem(
                icon: Icon(
                  ExpIcons.tareas,
                  color: PALLETE_BLUE,
                ),
                label: 'Módulos',
                activeIcon: CircleAvatar(
                    radius: 25,
                    backgroundColor: Color.fromARGB(165, 255, 255, 255),
                    child: Icon(
                      ExpIcons.tareas,
                      color: PALLETE_BLUE,
                      size: 40,
                    ))),
            BottomNavigationBarItem(
                icon: Icon(
                  ExpIcons.paginas,
                  color: PALLETE_BLUE,
                ),
                label: 'Notas',
                activeIcon: CircleAvatar(
                    radius: 25,
                    backgroundColor: Color.fromARGB(165, 255, 255, 255),
                    child: Icon(
                      ExpIcons.paginas,
                      color: PALLETE_BLUE,
                      size: 40,
                    ))),
            BottomNavigationBarItem(
                icon: Icon(
                  ExpIcons.calificaciones,
                  color: PALLETE_BLUE,
                ),
                label: 'Tareas',
                activeIcon: CircleAvatar(
                    radius: 25,
                    backgroundColor: Color.fromARGB(165, 255, 255, 255),
                    child: Icon(
                      ExpIcons.calificaciones,
                      color: PALLETE_BLUE,
                      size: 40,
                    ))),
            BottomNavigationBarItem(
                icon: Icon(
                  ExpIcons.modulos,
                  color: PALLETE_BLUE,
                ),
                label: 'Páginas',
                activeIcon: CircleAvatar(
                    radius: 25,
                    backgroundColor: Color.fromARGB(165, 255, 255, 255),
                    child: Icon(
                      ExpIcons.modulos,
                      color: PALLETE_BLUE,
                      size: 40,
                    ))),
          ],
        ),
      ),
    );
  }

  String displayDate(String isoString) {
    return formatDate(DateTime.parse(isoString).toLocal(),
        [dd, '/', mm, ' ', hh, ':', nn, ' ', am]);
  }

  Future<void> _getUsername() async {
    dynamic userData = await _authenticationClient.userData;
    if (mounted) {
      setState(() {
        username = userData.username;
        avatar_url = userData.avatar;
      });
    }
  }

  void handleUrl(String url) async {
    List<String> enlaces = url.split(":");
    if (enlaces[0] == 'http') {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      } else {
        throw 'Could not launch: ' + enlaces[1];
      }
    }
    if (enlaces[0] == 'https') {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      } else {
        throw 'Could not launch: ' + enlaces[1];
      }
    }
    if (enlaces[0] == 'mailto') {
      Uri emailUri = Uri(
          scheme: "mailto",
          path: enlaces[1],
          query:
              encodeQueryParameters(<String, String>{'subject': '$materia'}));
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        throw 'Could not launch $emailUri';
      }
    }
  }

  String encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  void _pickFiles() async {
    setState(() {
      isLoading = true;
    });
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: assignment.extensions != null
            ? List<String>.from(assignment.extensions)
            : []);
      if (result != null) {
        for (PlatformFile file in result.files) {
          if (!_paths.contains(file.path)) {
            setState(() {
              _paths.add(file.path!);
              _files.add(file);
            });
          }
        }
      }
    } on PlatformException catch (e) {
      print("No se pudieron escoger archivos" + e.toString());
    } catch (ex) {
      print("No se pudieron escoger archivos" + ex.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  void _onSend(context) async {
    if (_files.isEmpty) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
                content: Text("No hay archivos seleccionados"),
                actions: [
                  TextButton(
                      child: Text("OK", style: ALERT_ACTION_STYLE),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ]);
          });
    } else {
      await _submitAssignment(context);
    }
  }

  Future<void> _submitAssignment(BuildContext context) async {
    final _pr = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: false);
    _pr.style(
        message: "Preparando el envio de archivos",
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600));
    await _pr.show();
    List<dynamic> uploadParams = await _getUploadParams();
    Fluttertoast.showToast(
        msg: "Subiendo archivos..",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);

    await _pr.hide();
    _handleClose();
    if (uploadParams.length == this._files.length) {
      final fuw = FileUploadWorker();
      // await fuw.init();
      await fuw.uploadFiles(uploadParams, this.assignment, _files);
      if (!(assignment.submitted) && !(assignment.locked)) {
        widget.onDone(this.assignment.id);
      }
    }
  }

  void _handleClose() {
    Navigator.of(context).pop();
  }

  Future<List<dynamic>> _getUploadParams() async {
    List<dynamic> uploadParams = [];
    for (var file in this._files) {
      FormData formData =
          FormData.fromMap({"name": file.name, "size": file.size});
      final response = await _submissionsAPI.getUploadParams(formData);
      if (response.data != null) {
        uploadParams.add({"response_data": response.data, "file": file});
      }
    }
    return (uploadParams);
  }
}
