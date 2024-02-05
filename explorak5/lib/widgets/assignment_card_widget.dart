import 'dart:async';

import 'package:badges/badges.dart' as badge;
import 'package:explorak5/api/assignments_api.dart';
import 'package:explorak5/screens/courses_provider.dart';
import 'package:flutter/material.dart';
import 'package:explorak5/screens/constants.dart';
import 'package:explorak5/models/assignment.dart';
import 'package:date_format/date_format.dart';
import 'package:get_it/get_it.dart';

import '../models/courses.dart';
import '../screens/assignment_description_screen.dart';

class AssignmentCard extends StatefulWidget {
  final Assignment assignment;
  final Course course;
  static bool showP = false;
  final Function(int assignmentId) onDone;

  AssignmentCard({
    required Key key,
    required this.assignment,
    required this.course,
    required this.onDone,
  }) : super(key: key);
  @override
  _AssignmentCardState createState() =>
      _AssignmentCardState(assignment, course, showP, onDone);
}

class _AssignmentCardState extends State<AssignmentCard> {
  final Assignment assignment;
  final Course course;
  bool showP;
  final Function(int assignmentId) onDone;

  _AssignmentCardState(this.assignment, this.course, this.showP, this.onDone);

  late Timer timer;
  final _assignmentsAPI = GetIt.instance<AssignmentsAPI>();
  late Widget assignmentImage;

  @override
  void initState() {
    super.initState();
    setImageByAssignment(assignment.id);
    timer = Timer.periodic(
        Duration(seconds: 10), (Timer t) => {_assignmentShowPoint()});
  }

  @override
  void dispose() async {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return badge.Badge(
        badgeStyle: badge.BadgeStyle(badgeColor: Colors.green),
        badgeContent: Text(
          " ",
          style: TextStyle(color: Colors.white, fontSize: 60),
        ),
        position: badge.BadgePosition.topEnd(top: -30, end: 5),
        // aquí está el valor a cambiar para el punto verde
        showBadge: showP,
        child: Card(
            shape: ROUNDED_CORNERS_SHAPE,
            color: Colors.white,
            shadowColor: PALLETE_BLUE,
            elevation: CARD_ELEVATION,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                        GestureDetector(
                          //permite hacer clic en tarjeta para ver descripcion de tarea
                          onTap: () {
                            print("Tap: " + assignment.id.toString());
                            for (var course
                                in CoursesProvider.availableCourses) {
                              if (course.id == assignment.courseId) {
                                setState(() {
                                  assignment.showPoint = false;
                                  showP = false;
                                  course.showPoint = false;
                                });
                              }
                            }
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    AssignmentDescriptionScreen(
                                        key: UniqueKey(),
                                        course: course,
                                        assignment: assignment,
                                        onDone: (value) {},)));
                          },
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.center,
                                    child: assignmentImage),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Container(
                                          padding: CARD_ASSIGNMENT_PADDING,
                                          width: 280,
                                          child: Text(
                                            assignment.name,
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.start,
                                            style: CARD_ASSIGNMENT_STYLE,
                                          )),
                                      Container(
                                          padding: CARD_ASSIGNMENT_PADDING,
                                          width: 120,
                                          child: (assignment.locked)
                                              ? Column(children: <Widget>[
                                                  Text(
                                                    "Bloqueado hasta:",
                                                    overflow: TextOverflow.clip,
                                                    textAlign: TextAlign.start,
                                                    style:
                                                        CARD_ASSIGNMENT_STYLE,
                                                  ),
                                                  Text(
                                                    displayDate(
                                                        assignment.unlockAt),
                                                    overflow: TextOverflow.clip,
                                                    textAlign: TextAlign.start,
                                                  )
                                                ])
                                              : ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        PALLETE_BLUE,
                                                    padding: PADDING_MEDIUM,
                                                  ),
                                                  child: Padding(
                                                    padding: PADDING_SMALL,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              BUTTON_PADDING,
                                                          child: Icon(
                                                            Icons.send,
                                                            size: 20,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        Text(
                                                          assignment.submitted
                                                              ? "Reenviar"
                                                              : "Enviar",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style:
                                                              CARD_BUTTON_STYLE,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AssignmentDescriptionScreen( 
                                                                    key: UniqueKey(),
                                                                    assignment:
                                                                        assignment,
                                                                    course:
                                                                        course,
                                                                    onDone:
                                                                        onDone)));
                                                  },
                                                )),
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Container(
                                          padding: CARD_ASSIGNMENT_PADDING,
                                          width: 280,
                                          child: Row(children: <Widget>[
                                            Icon(Icons.calendar_today,
                                                color: Colors.grey),
                                            Text(
                                              displayDate(assignment.dueAt),
                                              overflow: TextOverflow.clip,
                                              textAlign: TextAlign.start,
                                              style: CARD_ASSIGNMENT_STYLE,
                                            ),
                                          ])),
                                      Container(
                                          padding: CARD_ASSIGNMENT_PADDING,
                                          width: 120,
                                          child: Row(children: <Widget>[
                                            Icon(
                                                assignment.submitted
                                                    ? Icons.assignment_turned_in
                                                    : Icons.pending_actions,
                                                color: Colors.grey),
                                            Text(
                                              assignment.submitted
                                                  ? "Entregado!"
                                                  : "Pendiente",
                                              overflow: TextOverflow.clip,
                                              textAlign: TextAlign.start,
                                              style: CARD_ASSIGNMENT_STYLE,
                                            ),
                                          ])),
                                    ])
                              ]),
                        )
                      ]))
                ])));
  }

  String displayDate(String isoString) {
    return formatDate(DateTime.parse(isoString).toLocal(),
        [dd, '/', mm, ' ', hh, ':', nn, ' ', am]);
  }

  void _assignmentShowPoint() {
    if (assignment.showPoint) {
      setState(() {
        showP = true;
      });
    }
  }

  void setImageByAssignment(int assignmentId) {
    String path = _assignmentsAPI.getAssignmentImg(assignmentId);
    print(path);
    assignmentImage = Image.network(path,
        color: (assignment.locked || assignment.submitted)
            ? Colors.grey
            : Colors.transparent,
        colorBlendMode: BlendMode.saturation,
        width: 370,
        fit: BoxFit.fitWidth, errorBuilder: (context, error, stackTrace) {
      return Image.network(DEFAULT_IMAGE,
          color: (assignment.locked || assignment.submitted)
              ? Colors.grey
              : Colors.transparent,
          colorBlendMode: BlendMode.saturation,
          width: 370,
          fit: BoxFit.fitWidth);
    });
  }
}
