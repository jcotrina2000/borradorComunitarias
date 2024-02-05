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

class PendingAssignmentsScreen extends StatefulWidget {
  final Course course;

  PendingAssignmentsScreen({required Key key, required this.course}) : super(key: key);

  @override
  _PendingAssignmentsScreen createState() => _PendingAssignmentsScreen(course);
}

class _PendingAssignmentsScreen extends State<PendingAssignmentsScreen> {
  final Course course;
  _PendingAssignmentsScreen(this.course);

  late Timer timer;
  bool isLoading = false;
  AssignmentProvider _assignment = new AssignmentProvider();
  AutoUpdate autoUpdate = new AutoUpdate();
  final _assignmentsAPI = GetIt.instance<AssignmentsAPI>();
  bool isVisible1 = true;
  bool isVisible2 = false;
  late bool isConnected;
  String courseName = " ";

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
            thickness: 10, //width of scrollbar
            radius: Radius.circular(20), //corner radius of scrollbar
            scrollbarOrientation: ScrollbarOrientation.left,
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
                                  thickness: 5,
                                  radius: Radius.circular(10),
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
