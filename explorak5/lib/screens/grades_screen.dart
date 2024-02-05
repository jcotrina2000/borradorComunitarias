import 'dart:async';
import 'package:explorak5/models/periods.dart';
import 'package:explorak5/screens/grades_provider.dart';
import 'package:flutter/material.dart';
import 'package:explorak5/screens/constants.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../api/grades_api.dart';
import '../api/periods_api.dart';
import '../models/category.dart';
import '../models/courses.dart';
import '../models/grades.dart';

class GradesScreen extends StatefulWidget {
  final Course course;

  GradesScreen({required Key key, required this.course}) : super(key: key);

  @override
  _GradesScreen createState() => _GradesScreen(course);
}

class _GradesScreen extends State<GradesScreen> {
  final Course course;
  _GradesScreen(this.course);

  late Timer timer;
  bool isLoading = false;
  GradesProvider _grades = new GradesProvider();
  final _gradesAPI = GetIt.instance<GradesAPI>();
  final _periodsAPI = GetIt.instance<PeriodsAPI>();
  late bool isConnected;
  String courseName = " ";
  String selectedPeriod = "Todos los periodos";
  List<String> periodsTitle = ["Todos los periodos"];

  List<bool> values = [];
  List<Category> categories = [];
  List<TableRow> gradeRows = [];
  List<TableRow> categoriesRows = [];
  List<double> puntajes = [];

  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getGrades();
      await _getPeriods();
    });
    super.initState();
    courseName = course.name;
    //update grades each 10 seconds
    // timer = Timer.periodic(Duration(seconds: 10), (Timer t) => {_getGrades()});
  }

  @override
  void dispose() async {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _grades,
      child: Consumer<GradesProvider>(
        builder: (context, GradesProvider gradesListProvider, child) =>
            Scrollbar(
          thickness: 10, //width of scrollbar
          radius: Radius.circular(20), //corner radius of scrollbar
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
                        child:
                            Text("Mis Calificaciones", style: SCREEN_HEADER))),
                Padding(
                    padding: PADDING_SMALL,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Periodo de Calificación",
                            style: SCREEN_MENU_HEADER))),
                Padding(
                    padding: PADDING_SMALL,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10.0, 0),
                          color: PALLETE_GRAY_3,
                          child: DropdownButton(
                            dropdownColor: PALLETE_GRAY_3,
                            underline: Container(),
                            value: selectedPeriod,
                            items: periodsTitle.map((String p) {
                              return DropdownMenuItem(
                                value: p,
                                child: Text(p),
                              );
                            }).toList(),
                            onChanged: (String? newP) {
                              print(newP);
                              setState(() {
                                selectedPeriod = newP!;
                              });
                            },
                          )),
                    )),
                (categories.length == 0)
                    ? Padding(
                        padding: PADDING_MEDIUM,
                        child: Container(
                            child: Column(
                          children: [
                            Icon(
                              Icons.assignment,
                              size: 40,
                              color: PALLETE_RED,
                            ),
                            Text("Sin calificaciones para mostrar",
                                textAlign: TextAlign.center,
                                style: NO_ASSIGNMENTS_TEXT_STYLE)
                          ],
                        )))
                    : Container(
                        padding: PADDING_MEDIUM,
                        color: PALLETE_BLUE,
                        margin: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              IconButton(
                                alignment: Alignment.centerLeft,
                                iconSize: 40,
                                color: Colors.white,
                                onPressed: () {
                                  print("Hola mundo");
                                },
                                icon: Icon(Icons.arrow_right),
                              ),
                              SizedBox(
                                  width: 210,
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Categoría",
                                          style: LIST_TITLE_STYLE))),
                              SizedBox(
                                  width: 90,
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Puntaje",
                                        style: LIST_TITLE_STYLE,
                                        textAlign: TextAlign.end,
                                      ))),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "De",
                                    style: LIST_TITLE_STYLE,
                                    textAlign: TextAlign.end,
                                  )),
                            ])),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      double newValue = 0.0;
                      if (puntajes[index] == 0) {
                        newValue = 0.0;
                      } else {
                        newValue = categories[index].weight / puntajes[index];
                      }
                      return Container(
                          padding: PADDING_MEDIUM,
                          color: PALLETE_BLUE,
                          margin: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      IconButton(
                                        alignment: Alignment.centerLeft,
                                        iconSize: 40,
                                        color: Colors.white,
                                        onPressed: () {
                                          for (int i = 0;
                                              i < values.length;
                                              i++) {
                                            if (i != index) {
                                              values[i] = false;
                                            }
                                          }
                                          setState(() {
                                            print(index);
                                            values[index] = !values[index];
                                            gradesRows(categories[index].id);
                                          });
                                        },
                                        icon: values[index]
                                            ? Icon(Icons.arrow_drop_down)
                                            : Icon(Icons.arrow_right),
                                      ),
                                      SizedBox(
                                          width: 215,
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  categories[index].name,
                                                  style: LIST_TITLE_STYLE))),
                                      SizedBox(
                                          width: 70,
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                newValue.toStringAsFixed(2) +
                                                    "%",
                                                style: LIST_TITLE_STYLE,
                                                textAlign: TextAlign.end,
                                              ))),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            categories[index]
                                                    .weight
                                                    .toString() +
                                                "%",
                                            style: LIST_TITLE_STYLE,
                                            textAlign: TextAlign.end,
                                          )),
                                    ]),
                                Visibility(
                                  visible: values[index],
                                  child: Table(
                                      columnWidths: {
                                        0: FlexColumnWidth(13),
                                        1: FlexColumnWidth(3),
                                        2: FlexColumnWidth(4),
                                      },
                                      border: TableBorder.symmetric(
                                          inside: BorderSide(
                                              width: 1, color: PALLETE_BLUE)),
                                      children: gradeRows),
                                )
                              ]));
                    }),
              ])),
        ),
      ),
    );
  }

  Future<void> _getGrades() async {
    setState(() {
      this.isLoading = true;
    });
    Map<String, List<Grades>> grades = {};
    List<Grades> notitas = [];
    final response = await _gradesAPI.getAssignmentGroups(course.id);
    if (response.data != null) {
      for (var notas in response.data) {
        Category categoria = Category.fromJson(notas);
        categories.add(categoria);
        values.add(false);
        double prom = 0.0;
        double index = 0.0;
        if (notas["assignments"] != null) {
          for (var tareas in notas["assignments"]) {
            Grades gradesUnit = Grades.fromJson(tareas);
            prom = prom + gradesUnit.currentScore;
            index++;
            notitas.add(gradesUnit);
          }
          grades.putIfAbsent(categoria.id.toString(), () => notitas);
        }
        puntajes.add(prom / index);
      }
      _grades.setGradesResult(grades);
    }

    setState(() {
      this.isLoading = false;
    });
  }

  void gradesRows(int groupId) {
    List<TableRow> notasFilas = [];
    double puntaje = 0.0;
    double total = 0.0;
    int indice = 0;
    notasFilas.add(
        TableRow(decoration: BoxDecoration(color: PALLETE_GRAY_3), children: [
      Padding(
          padding: PADDING_SMALL,
          child: Text("Actividad",
              textAlign: TextAlign.left, style: TABLE_CONTENT)),
      Text("Nota", textAlign: TextAlign.center, style: TABLE_CONTENT),
      Text("Puntaje", textAlign: TextAlign.center, style: TABLE_CONTENT)
    ]));
    if (selectedPeriod == "Todos los periodos") {
      for (Grades nota in GradesProvider.getGrades[groupId.toString()]!) {
        if (groupId == nota.groupId) {
          puntaje = puntaje + nota.currentScore;
          total = total + nota.maxScore;
          indice++;
          notasFilas.add(TableRow(
              decoration: BoxDecoration(color: PALLETE_GRAY_3),
              children: [
                Padding(
                    padding: PADDING_SMALL,
                    child: Text(nota.name,
                        textAlign: TextAlign.left, style: TABLE_CONTENT)),
                Text(nota.currentScore.toStringAsFixed(2),
                    textAlign: TextAlign.center, style: TABLE_CONTENT),
                Text(nota.maxScore.toStringAsFixed(2),
                    textAlign: TextAlign.center, style: TABLE_CONTENT)
              ]));
        }
      }
    } else {
      for (Grades nota in GradesProvider.getGrades[groupId.toString()]!) {
        Periods per = GradesProvider.getPeriods
            .firstWhere((value) => value.title == selectedPeriod);
        if (nota.termId == per.id && groupId == nota.groupId) {
          puntaje = puntaje + nota.currentScore;
          total = total + nota.maxScore;
          indice++;
          notasFilas.add(TableRow(
              decoration: BoxDecoration(color: PALLETE_GRAY_3),
              children: [
                Padding(
                    padding: PADDING_SMALL,
                    child: Text(nota.name,
                        textAlign: TextAlign.left, style: TABLE_CONTENT)),
                Text(nota.currentScore.toStringAsFixed(2),
                    textAlign: TextAlign.center, style: TABLE_CONTENT),
                Text(nota.maxScore.toStringAsFixed(2),
                    textAlign: TextAlign.center, style: TABLE_CONTENT),
              ]));
        }
      }
    }
    notasFilas.add(
        TableRow(decoration: BoxDecoration(color: PALLETE_GRAY_3), children: [
      Padding(
          padding: PADDING_SMALL,
          child:
              Text("Total", textAlign: TextAlign.left, style: TABLE_CONTENT)),
      Text((puntaje / indice).toStringAsFixed(2),
          textAlign: TextAlign.center, style: TABLE_CONTENT),
      Text((total / indice).toStringAsFixed(2),
          textAlign: TextAlign.center, style: TABLE_CONTENT)
    ]));
    setState(() {
      if (notasFilas.length > 0) {
        gradeRows = notasFilas;
      } else {
        gradeRows = [];
      }
    });
  }

  void categoriesByRow() {
    List<TableRow> categoriasFilas = [];
    categoriasFilas.add(
        TableRow(decoration: BoxDecoration(color: PALLETE_BLUE), children: [
      Text("Categorias", textAlign: TextAlign.center, style: TABLE_HEADER),
      Text("Puntaje", textAlign: TextAlign.center, style: TABLE_HEADER),
      Text("De", textAlign: TextAlign.center, style: TABLE_HEADER)
    ]));
    int index = 0;
    for (Category cat in categories) {
      categoriasFilas.add(
          TableRow(decoration: BoxDecoration(color: PALLETE_BLUE), children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                alignment: Alignment.centerLeft,
                iconSize: 40,
                color: Colors.white,
                onPressed: () {
                  for (int i = 0; i < values.length; i++) {
                    if (i != index) {
                      values[i] = false;
                    }
                  }
                  setState(() {
                    print(index);
                    values[index] = !values[index];
                    gradesRows(cat.id);
                  });
                },
                icon: values[index]
                    ? Icon(Icons.arrow_drop_down, color: PALLETE_BLUE)
                    : Icon(Icons.arrow_right, color: PALLETE_BLUE),
              ),
              SizedBox(
                  width: 250,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(cat.name, style: SCREEN_MENU_HEADER))),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    cat.weight.toString() + "%",
                    style: SCREEN_MENU_HEADER,
                    textAlign: TextAlign.end,
                  )),
            ]),
        Visibility(
          visible: values[index],
          child: Padding(
              padding: PADDING_MEDIUM,
              child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(13),
                    1: FlexColumnWidth(4),
                    2: FlexColumnWidth(3),
                  },
                  border: TableBorder.symmetric(
                      inside: BorderSide(width: 1, color: Colors.blue),
                      outside: BorderSide(width: 2, color: Colors.blue)),
                  children: gradeRows)),
        )
      ]));
      index++;
    }
    categoriasFilas.add(
        TableRow(decoration: BoxDecoration(color: PALLETE_BLUE), children: [
      Text("Total", textAlign: TextAlign.center, style: TABLE_HEADER),
      Text("8", textAlign: TextAlign.center, style: TABLE_HEADER),
      Text("10", textAlign: TextAlign.center, style: TABLE_HEADER)
    ]));
  }

  Future<void> _getPeriods() async {
    setState(() {
      this.isLoading = true;
    });

    final response = await _periodsAPI.getCoursePeriods(course.id);
    if (response.data != null) {
      List<Periods> listPeriodos = [];
      for (var periodo in response.data["grading_periods"]) {
        print(periodo);
        Periods period = Periods.fromJson(periodo);
        listPeriodos.add(period);
        periodsTitle.add(period.title);
      }
      _grades.setPeriods(listPeriodos);
    }

    setState(
      () {
        this.isLoading = false;
      },
    );
  }
}
