import 'package:explorak5/exp_icons_icons.dart';
import 'package:explorak5/screens/assignments_screen.dart';
import 'package:explorak5/screens/module_screen.dart';
import 'package:explorak5/screens/pages_screen.dart';
import 'package:explorak5/screens/pending_assignment_screen.dart';
import 'package:explorak5/screens/grades_screen.dart';
import 'package:explorak5/services/auto_update.dart';
import 'package:flutter/material.dart';
import 'package:explorak5/screens/constants.dart';
import '../models/courses.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/side_menu_widget.dart';

class BaseScreen extends StatefulWidget {
  final Course course;

  BaseScreen({
    required Key key,
    required this.course,
  }) : super(key: key);
  @override
  _BaseScreen createState() => _BaseScreen(course);
}

class _BaseScreen extends State<BaseScreen> {
  final Course course;
  late AutoUpdate autoUpdate;
  late bool isVisible1;
  late bool isVisible2;
  late bool? isConnected;
  int selectedScreen = 0;
  List<dynamic> screens = [];

  _BaseScreen(this.course) {
    autoUpdate = AutoUpdate();
    isVisible1 = true;
    isVisible2 = false;
    isConnected = null;
  }

  void initState() {
  super.initState();
  screens.add(PendingAssignmentsScreen(course: course, key: UniqueKey()));
  screens.add(ListAssignmentsScreen(course: course, key: UniqueKey()));
  screens.add(GradesScreen(course: course, key: UniqueKey()));
  screens.add(ModulesScreen(course: course, key: UniqueKey()));
  screens.add(PageScreen(course: course, key: UniqueKey()));
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
        body: screens[selectedScreen],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              selectedScreen = value;
            });
          },
          currentIndex: selectedScreen,
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
                    backgroundColor: Color.fromARGB(255, 225, 225, 225),
                    child: Icon(
                      ExpIcons.inicio_active,
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
                    backgroundColor: Color.fromARGB(255, 225, 225, 225),
                    child: Icon(
                      ExpIcons.tareas_active,
                      color: PALLETE_BLUE,
                      size: 40,
                    ))),
            BottomNavigationBarItem(
                icon: Icon(
                  ExpIcons.calificaciones,
                  color: PALLETE_BLUE,
                ),
                label: 'Notas',
                activeIcon: CircleAvatar(
                    radius: 25,
                    backgroundColor: Color.fromARGB(255, 225, 225, 225),
                    child: Icon(
                      ExpIcons.calificaciones_active,
                      color: PALLETE_BLUE,
                      size: 40,
                    ))),
            BottomNavigationBarItem(
                icon: Icon(
                  ExpIcons.paginas,
                  color: PALLETE_BLUE,
                ),
                label: 'Tareas',
                activeIcon: CircleAvatar(
                    radius: 25,
                    backgroundColor: Color.fromARGB(255, 225, 225, 225),
                    child: Icon(
                      ExpIcons.paginas_active,
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
                    backgroundColor: Color.fromARGB(255, 225, 225, 225),
                    child: Icon(
                      ExpIcons.modulos_active,
                      color: PALLETE_BLUE,
                      size: 40,
                    ))),
          ],
        ),
      ),
    );
  }
}
