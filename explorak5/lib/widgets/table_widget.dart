import 'dart:async';
import 'package:explorak5/models/category.dart';
import 'package:flutter/material.dart';

import '../models/grades.dart';
import '../models/periods.dart';
import '../screens/constants.dart';
import '../screens/grades_provider.dart';

class TableGrade extends StatefulWidget {
  final List<Category> categories;
  final String selectedPeriod;

  TableGrade({
    required Key key,
    required this.categories,
    required this.selectedPeriod,
  }) : super(key: key);
  @override
  _TableGradeState createState() =>
      _TableGradeState(categories, selectedPeriod);
}

class _TableGradeState extends State<TableGrade> {
  final List<Category> categories;
  final String selectedPeriod;
  _TableGradeState(this.categories, this.selectedPeriod);
  List<bool> values = [];
  List<TableRow> gradeRows = [];
  List<TableRow> categoriesRows = [];

  Timer? timer;

  @override
  void initState() {
    super.initState();
    rowsCategories();
  }

  @override
  void dispose() async {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Table(
        border: TableBorder.symmetric(
            inside: BorderSide(width: 1, color: PALLETE_BLUE),
            outside: BorderSide(width: 2, color: PALLETE_BLUE)),
        children: categoriesRows);
  }

  void rowsCategories() {
    List<TableRow> listRows = [];
    listRows.add(
        TableRow(decoration: BoxDecoration(color: PALLETE_BLUE), children: [
      Text(" ", textAlign: TextAlign.center, style: TABLE_HEADER),
      Text("Categorias", textAlign: TextAlign.center, style: TABLE_HEADER),
      Text("Puntaje", textAlign: TextAlign.center, style: TABLE_HEADER),
    ]));
    for (Category cat in categories) {
      int index = categories.indexOf(cat);
      values.add(false);
      listRows.add(
          TableRow(decoration: BoxDecoration(color: PALLETE_BLUE), children: [
        IconButton(
            alignment: Alignment.centerLeft,
            iconSize: 40,
            color: Colors.white,
            onPressed: () {
              // for (int i = 0; i < values.length; i++) {
              //   values[i] = false;
              // }
              setState(() {
                values[index] = !values[index];
                print(values[index]);
                gradesRows(cat.id);
              });
            },
            icon: Icon(
                (values[index]) ? Icons.arrow_drop_down : Icons.arrow_right)),
        Padding(
            padding: PADDING_MEDIUM,
            child: Text(cat.name, style: LIST_TITLE_STYLE)),
        Align(
            alignment: Alignment.centerRight,
            child: Text(
              cat.weight.toString() + "%",
              style: LIST_TITLE_STYLE,
              textAlign: TextAlign.end,
            )),
      ]));
      listRows.add(
          TableRow(decoration: BoxDecoration(color: PALLETE_BLUE), children: [
        Text("data"),
        Text("data"),
        Visibility(
          visible: values[index],
          child: Table(children: gradeRows),
        )
      ]));
    }
    setState(() {
      if (listRows.length > 1) {
        categoriesRows = listRows;
      } else {
        categoriesRows = [];
      }
    });
  }

  void gradesRows(int groupId) {
    List<TableRow> notasFilas = [];
    double puntaje = 0.0;
    if (selectedPeriod == "Todos los periodos") {
      for (Grades nota in GradesProvider.getGrades[groupId.toString()]!) {
        if (groupId == nota.groupId) {
          puntaje = puntaje + nota.currentScore;
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
    } else {
      for (Grades nota in GradesProvider.getGrades[groupId.toString()]!) {
        Periods per = GradesProvider.getPeriods
            .firstWhere((value) => value.title == selectedPeriod);
        if (nota.termId == per.id && groupId == nota.groupId) {
          puntaje = puntaje + nota.currentScore;
          notasFilas.add(TableRow(
              decoration: BoxDecoration(color: Colors.white),
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
    gradeRows = notasFilas;
    setState(() {
      gradeRows = notasFilas;
    });
  }
}
