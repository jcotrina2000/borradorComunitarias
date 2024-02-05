import 'dart:async';
import 'package:explorak5/api/assignments_api.dart';
import 'package:explorak5/services/auto_update.dart';
import 'package:flutter/material.dart';
import 'package:explorak5/screens/constants.dart';
import 'package:explorak5/screens/assignment_provider.dart';
import 'package:explorak5/widgets/assignment_card_widget.dart';
import 'package:explorak5/models/assignment.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../models/courses.dart';

class ListAssignmentsScreen extends StatefulWidget {
  final Course course;

  ListAssignmentsScreen({required Key key, required this.course}) : super(key: key);

  @override
  _ListAssignmentsScreen createState() => _ListAssignmentsScreen(course);
}

class _ListAssignmentsScreen extends State<ListAssignmentsScreen> {
  final Course course;
  late Timer timer;
  late bool isLoading;
  AssignmentProvider _assignment = AssignmentProvider();
  AutoUpdate autoUpdate = AutoUpdate();
  final _assignmentsAPI = GetIt.instance<AssignmentsAPI>();
  late bool isVisible1;
  late bool isVisible2;
  late bool? isConnected;
  late String courseName;

  _ListAssignmentsScreen(this.course) {
    isLoading = false;
    isVisible1 = true;
    isVisible2 = false;
    isConnected = null;
    courseName = '';
  }

  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
    courseName = course.name;
    //update assignments each 10 seconds
    timer = Timer.periodic(
        Duration(seconds: 10), (Timer t) => {_refreshAssignments(course)});
  }

  @override
  void dispose() async {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => _assignment,
        child: Consumer<AssignmentProvider>(
          builder:
              (context, AssignmentProvider assignmentsListProvider, child) =>
                  Scrollbar(
            thickness: 10,
            radius: Radius.circular(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                      padding: PADDING_SMALL,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("$courseName", style: SCREEN_HEADER))),
                  Padding(
                      padding: PADDING_SMALL,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Mis Tareas", style: SCREEN_HEADER))),
                  Container(
                      padding: PADDING_MEDIUM,
                      color: PALLETE_BLUE,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            IconButton(
                                alignment: Alignment.centerLeft,
                                iconSize: 40,
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    isVisible1 = !isVisible1;
                                  });
                                },
                                icon: Icon((isVisible1)
                                    ? Icons.arrow_drop_down
                                    : Icons.arrow_right)),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Actividades pendientes",
                                    style: LIST_TITLE_STYLE)),
                          ])),
                  (AssignmentProvider.toDoList.length == 0)
                      ? Padding(
                          padding: PADDING_LARGE,
                          child: Container(
                              child: Column(
                            children: [
                              Icon(
                                Icons.assignment,
                                size: 40,
                                color: PALLETE_RED,
                              ),
                              Text("Sin tareas para mostrar",
                                  style: NO_ASSIGNMENTS_TEXT_STYLE)
                            ],
                          )))
                      : Padding(
                          padding: PADDING_SMALL,
                          child: isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      THEME_COLOR),
                                ))
                              : Scrollbar(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          AssignmentProvider.toDoList.length,
                                      itemBuilder: (context, index) {
                                        return Visibility(
                                            visible: isVisible1,
                                            child: AssignmentCard(
                                              key: UniqueKey(),
                                              assignment: AssignmentProvider
                                                  .toDoList[index],
                                              course: course,
                                              onDone: (assignmentId) {
                                                assignmentsListProvider
                                                    .updateList(assignmentId);
                                              },
                                            ));
                                      })),
                        ),
                  Container(
                      padding: PADDING_MEDIUM,
                      color: PALLETE_BLUE,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            IconButton(
                                alignment: Alignment.centerLeft,
                                iconSize: 40,
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    isVisible2 = !isVisible2;
                                  });
                                },
                                icon: Icon((isVisible2)
                                    ? Icons.arrow_drop_down
                                    : Icons.arrow_right)),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Actividades anteriores",
                                    style: LIST_TITLE_STYLE)),
                          ])),
                  (AssignmentProvider.submittedList.length == 0)
                      ? Padding(
                          padding: PADDING_LARGE,
                          child: Container(
                              child: Column(
                            children: [
                              Icon(
                                Icons.assignment,
                                size: 40,
                                color: PALLETE_RED,
                              ),
                              Text("Sin tareas para mostrar",
                                  textAlign: TextAlign.center,
                                  style: NO_ASSIGNMENTS_TEXT_STYLE)
                            ],
                          )))
                      : Padding(
                          padding: PADDING_SMALL,
                          child: isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      THEME_COLOR),
                                ))
                              : Scrollbar(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: AssignmentProvider
                                          .submittedList.length,
                                      itemBuilder: (context, index) {
                                        var assignment = AssignmentProvider
                                            .submittedList[index];
                                        //Crea una tarjeta usando los datos de una tarea en la lista
                                        return Visibility(
                                            visible: isVisible2,
                                            child: AssignmentCard(
                                                key: UniqueKey(),
                                                assignment: assignment,
                                                course: course, onDone: (value) {},
                                                ));
                                      })),
                        ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> _getAssignments(Course course) async {
    if (this.isLoading) {
      return;
    }

    if (mounted) {
      setState(() {
        this.isLoading = true;
      });
    }

    Map<String, List<Assignment>> assignments = {};
    final response = await _assignmentsAPI.getAssignments(course.id);
    if (response.data != null) {
      List<Assignment> toDo = [];
      List<Assignment> submitted = [];
      for (var assignment in response.data) {
        List<dynamic> submissionTypes = assignment["submission_types"];
        if (!(assignment["is_quiz_assignment"]) &&
            submissionTypes.contains("online_upload")) {
          Assignment assign = Assignment.fromJson(assignment);
          // setAssignmentImage(assign);
          if (!(assign.submitted) && !(assign.locked)) {
            toDo.add(assign);
          } else {
            submitted.add(assign);
          }
        }
      }
      assignments.putIfAbsent("toDo", () => toDo);
      assignments.putIfAbsent("submitted", () => submitted);
    }
    if (mounted) {
      setState(() {
        _assignment.setAssignmentResult(assignments);
        this.isLoading = false;
      });
    }
  }

  void _refreshAssignments(course) async {
    if (await autoUpdate.getAssignments(course)) {
      _getAssignments(course);
    }
  }
}
