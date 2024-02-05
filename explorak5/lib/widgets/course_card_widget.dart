import 'dart:async';
import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:explorak5/models/courses.dart';
import 'package:date_format/date_format.dart';
import 'package:explorak5/screens/constants.dart';
import '../screens/base_screen.dart';

class CourseCard extends StatefulWidget {
  final Course course;
  final String color;

  CourseCard({
    required Key key,
    required this.course,
    required this.color,
  }) : super(key: key);
  @override
  _CourseCardState createState() => _CourseCardState(course, color);
}

class _CourseCardState extends State<CourseCard> {
  final Course course;
  final String color;
  bool showP = false;
  _CourseCardState(this.course, this.color);

  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
        Duration(seconds: 10), (Timer t) => {_courseShowPoint()});
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
            color: Color(hexColor(color)),
            shadowColor: PALLETE_BLUE,
            elevation: CARD_ELEVATION,
            child: Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                  Expanded(
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                        GestureDetector(
                          //permite hacer clic en tarjeta para ver descripcion de tarea
                          onTap: () {
                            setState(() {
                              course.showPoint = false;
                              showP = false;
                            });
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    BaseScreen(course: course, key: UniqueKey())));
                          },
                          child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.center,
                                    child: Image.network(
                                      course.image,
                                      width: 170,
                                      height: 170,
                                    )),
                                Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      course.name,
                                      style: CARD_TITLE_COURSE_STYLE,
                                      textAlign: TextAlign.center,
                                    )),
                              ]),
                        )
                      ]))
                ]))));
  }

  int hexColor(String input) {
    String newColor = '0xff' + input.substring(1);
    newColor.replaceAll('#', '');
    int finalColor = int.parse(newColor);
    return finalColor;
  }

  String displayDate(String isoString) {
    return formatDate(
        DateTime.parse(isoString).toLocal(), [dd, '/', mm, hh, ':', nn, am]);
  }

  void _courseShowPoint() {
    if (course.showPoint) {
      setState(() {
        showP = true;
      });
    }
  }
}
