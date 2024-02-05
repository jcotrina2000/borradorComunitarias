import 'dart:async';

import 'package:explorak5/screens/pages_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
//import '../api/pages_api.dart';
import '../models/courses.dart';
//import '../models/pages.dart';
import 'constants.dart';

class PageScreen extends StatefulWidget {
  final Course course;

  PageScreen({required Key key, required this.course}) : super(key: key);

  @override
  _PageScreen createState() => _PageScreen(course);
}

class _PageScreen extends State<PageScreen> {
  final Course course;
  _PageScreen(this.course);
  late String courseName;
  late Timer timer;
  bool isLoading = false;
  PageProvider _modules = new PageProvider();
  //final _pageAPI = GetIt.instance<PagesAPI>();

  get autoUpdate => null;

  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
    courseName = course.name;
    //update modules each 10 seconds
    // timer = Timer.periodic(
    //     Duration(seconds: 10), (Timer t) => {_refreshPages(course)});
  }

  @override
  void dispose() async {
    timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => _modules,
        child: Consumer<PageProvider>(
            builder: (context, PageProvider modeulesListProvider, child) =>
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
                                  child: Text("$courseName",
                                      style: SCREEN_HEADER))),
                          Padding(
                              padding: PADDING_SMALL,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Mis Módulos",
                                      style: SCREEN_HEADER))),
                          (PageProvider.modules.length == 0)
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
                                      Text("Sin página frontal para mostrar",
                                          textAlign: TextAlign.center,
                                          style: NO_ASSIGNMENTS_TEXT_STYLE)
                                    ],
                                  )))
                              : Padding(
                                  padding: PADDING_SMALL,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  THEME_COLOR))))
                        ])))));
  }

  // Future<void> _getPages(Course course) async {
  //   if (this.isLoading) {
  //     return;
  //   }

  //   if (mounted) {
  //     setState(() {
  //       this.isLoading = true;
  //     });
  //   }

  //   final response = await _pageAPI.getPages(course.id);
  //   if (response.data != null) {
  //     Page pagina = Pages.fromJson(response.data);
  //   }
  //   if (mounted) {
  //     setState(() {
  //       _page.setPageResult(listado);
  //       this.isLoading = false;
  //     });
  //   }
  // }

  // void _refreshPages(course) async {
  //   if (await autoUpdate.getPages(course)) {
  //     _getPages(course);
  //   }
  // }
}
