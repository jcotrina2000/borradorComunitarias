import 'dart:async';
import 'package:explorak5/screens/base_screen.dart';
import 'package:explorak5/services/authentication_client.dart';
import 'package:explorak5/services/auto_update.dart';
import 'package:explorak5/widgets/side_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:explorak5/screens/constants.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../api/courses_api.dart';
import '../api/courses_color_api.dart';
import '../models/courses.dart';
import '../services/notifications_client.dart';
import '../services/wifi_connection.dart';
import '../widgets/about_alert_widget.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/course_card_widget.dart';
import 'courses_provider.dart';
import 'login_screen.dart';

class CoursesScreen extends StatefulWidget {
  CoursesScreen({required Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<CoursesScreen> {
  Timer? timer;
  String? username;
  String avatar_url = DEFAULT_IMAGE;
  bool isLoading = true;
  WifiConnection _connection = new WifiConnection();
  AutoUpdate autoUpdate = new AutoUpdate();
  var isConnected;
  Map<String, dynamic> colorsMap = new Map<String, dynamic>();
  NotificationCLient? service;

  CoursesProvider _courses = new CoursesProvider();
  final _authenticationClient = GetIt.instance<AuthenticationClient>();
  static final _coursesColorAPI = GetIt.instance<CoursesColorsAPI>();
  static final _coursesAPI = GetIt.instance<CoursesAPI>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getUsername();
      isConnected = await _connection.getConnectivity();
      service = NotificationCLient();
      service!.intialize();
      listenToNotification();
      if (isConnected) {
        await _getColors();
        await _getCourses();
      }
    });
    super.initState();
    //update new courses each 10 seconds
    timer =
        Timer.periodic(Duration(seconds: 10), (Timer t) => {_refreshCourses()});
  }

  @override
  void dispose() async {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _courses,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Explora K5",
          theme: ThemeData(primaryColor: THEME_COLOR, fontFamily: 'Quicksand'),
          home: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBarExplora(key: UniqueKey()),
            body: Consumer<CoursesProvider>(
              builder: (context, CoursesProvider coursesListProvider, child) =>
                  Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                      padding: PADDING_LARGE,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Inicio | Mis Materias",
                              style: SCREEN_MENU_HEADER))),
                  Flexible(
                    flex: CoursesProvider.availableCourses.length,
                    child: CoursesProvider.availableCourses.length == 0
                        ? Center(
                            child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(THEME_COLOR),
                          ))
                        : isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(THEME_COLOR),
                              ))
                            : Padding(
                                padding: PADDING_SMALL,
                                child: Scrollbar(
                                    thickness: 10,
                                    radius: Radius.circular(10),
                                    child: GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: 8 / 9,
                                                crossAxisSpacing: 5,
                                                mainAxisSpacing: 5),
                                        itemCount: CoursesProvider
                                            .availableCourses.length,
                                        itemBuilder: (context, index) {
                                          final course = CoursesProvider
                                              .availableCourses[index];
                                          final color =
                                              colorsMap[course.id.toString()];
                                          //Crea una tarjeta usando los datos de un curso en la lista
                                          return isLoading
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(THEME_COLOR),
                                                ))
                                              : CourseCard(
                                                  key: UniqueKey(),
                                                  course: course, color: color);
                                        }))),
                  )
                ],
              ),
            ),
            drawer: SideMenu(),
          )),
    );
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

  Future<void> _getCourses() async {
    setState(() {
      this.isLoading = true;
    });

    Map<String, List<Course>> cursos = {};
    final response = await _coursesAPI.getCourses();
    if (response.data != null) {
      List<Course> available = [];
      for (var course in response.data) {
        Course curso = Course.fromJson(course);
        // revisión de este workflow
        if (curso.workflowState == 'available' && curso.isPublic != false) {
          available.add(curso);
        }
      }
      cursos.putIfAbsent("available", () => available);
    }

    setState(() {
      _courses.setCoursesResult(cursos);
      this.isLoading = false;
    });
  }

  Future<void> _getColors() async {
    setState(() {
      this.isLoading = true;
    });
    Map<String, dynamic> mapaColor = {};
    final response = await _coursesColorAPI.getColors();
    if (response.data != null) {
      Map<String, dynamic> jsonData = Map<String, dynamic>.from(response.data);
      List<Map<String, dynamic>> jsonList = [jsonData["custom_colors"]];
      jsonList[0].forEach((key, value) {
        key = key.split("_")[1];
        mapaColor[key] = value;
      });
    }

    setState(() {
      colorsMap = mapaColor;
      this.isLoading = false;
    });
  }

  void _refreshCourses() async {
    await AutoUpdate.getNotifications();
    if (await autoUpdate.getCourses()) {
      _getCourses();
      _getColors();
    }
  }

  void handleMenuClick(String value) {
    switch (value) {
      case 'logout':
        _logout();
        return;
      case 'about':
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AboutAlert();
            });
        return;
    }
  }

  Future<void> _logout() async {
    dynamic userData = await _authenticationClient.userData;
    String token = userData.token;
    await _authenticationClient.deleteSession(token);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void listenToNotification() =>
      AutoUpdate.service.onNotificationClick.listen((payload) {
        Course? course;
        String courseId = payload.split(',')[0];
        for (Course curso in CoursesProvider.availableCourses) {
          if (curso.id == int.parse(courseId)) {
            setState(() {
              course = curso;
            });
            break;
          }
        }
        if (course != null)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BaseScreen(course: course!, key: UniqueKey()),
            ),
          );
      });
}
