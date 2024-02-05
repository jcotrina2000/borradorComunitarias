import 'dart:async';

import 'package:explorak5/models/modules.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../api/modules_api.dart';
import '../models/courses.dart';
import '../services/auto_update.dart';
import 'constants.dart';
import 'module_provider.dart';

class ModulesScreen extends StatefulWidget {
  final Course course;

  ModulesScreen({required Key key, required this.course}) : super(key: key);

  @override
  _ModulesScreen createState() => _ModulesScreen(course);
}

class _ModulesScreen extends State<ModulesScreen> {
  final Course course;
  _ModulesScreen(this.course);
  late Timer timer;
  bool isLoading = false;
  AutoUpdate autoUpdate = new AutoUpdate();
  String courseName = " ";
  ModuleProvider _modules = new ModuleProvider();
  final _moduleAPI = GetIt.instance<ModuleAPI>();

  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
    courseName = course.name;
    //update modules each 10 seconds
    timer = Timer.periodic(
        Duration(seconds: 10), (Timer t) => {_refreshModule(course)});
  }

  @override
  void dispose() async {
    timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => _modules,
        child: Consumer<ModuleProvider>(
            builder:
                (context, ModuleProvider modeulesListProvider, child) =>
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
                              (ModuleProvider.modules.length == 0)
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
                                          Text("Sin módulos para mostrar",
                                              textAlign: TextAlign.center,
                                              style: NO_ASSIGNMENTS_TEXT_STYLE)
                                        ],
                                      )))
                                  : Padding(
                                      padding: PADDING_SMALL,
                                      child: isLoading
                                          ? Center(
                                              child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      THEME_COLOR),
                                            ))
                                          : Scrollbar(
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: ModuleProvider
                                                      .modules.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var module = ModuleProvider
                                                        .modules[index];
                                                    //Crea una tarjeta usando los datos de una tarea en la lista
                                                    return Card(
                                                        shape:
                                                            ROUNDED_CORNERS_SHAPE,
                                                        color: Colors.white,
                                                        shadowColor:
                                                            PALLETE_BLUE,
                                                        elevation:
                                                            CARD_ELEVATION,
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: <Widget>[
                                                              Expanded(
                                                                  child: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                    Container(
                                                                        padding:
                                                                            CARD_ASSIGNMENT_PADDING,
                                                                        width:
                                                                            280,
                                                                        child:
                                                                            Text(
                                                                          module.name,
                                                                          overflow:
                                                                              TextOverflow.clip,
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                          style:
                                                                              CARD_ASSIGNMENT_STYLE,
                                                                        )),
                                                                    Container(
                                                                        padding:
                                                                            CARD_ASSIGNMENT_PADDING,
                                                                        width:
                                                                            280,
                                                                        child:
                                                                            Text(
                                                                          module.state,
                                                                          overflow:
                                                                              TextOverflow.clip,
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                          style:
                                                                              CARD_ASSIGNMENT_STYLE,
                                                                        )),
                                                                    Container(
                                                                        padding:
                                                                            CARD_ASSIGNMENT_PADDING,
                                                                        width:
                                                                            280,
                                                                        child:
                                                                            Text(
                                                                          module.workState,
                                                                          overflow:
                                                                              TextOverflow.clip,
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                          style:
                                                                              CARD_ASSIGNMENT_STYLE,
                                                                        )),
                                                                  ]))
                                                            ]));
                                                  })))
                            ])))));
  }

  Future<void> _getModules(Course course) async {
    if (this.isLoading) {
      return;
    }

    if (mounted) {
      setState(() {
        this.isLoading = true;
      });
    }

    Map<String, List<Modules>> listado = {};
    final response = await _moduleAPI.getModules(course.id);
    if (response.data != null) {
      List<Modules> listaModulos = [];
      for (var module in response.data) {
        if (module["workflow_state"] == "active" &&
            module["state"] == "started") {
          Modules modules = Modules.fromJson(module);
          listaModulos.add(modules);
        }
      }
      listado.putIfAbsent("modules", () => listaModulos);
    }
    if (mounted) {
      setState(() {
        _modules.setModulesResult(listado);
        this.isLoading = false;
      });
    }
  }

  void _refreshModule(course) async {
    if (await autoUpdate.getModules(course)) {
      _getModules(course);
    }
  }
}
