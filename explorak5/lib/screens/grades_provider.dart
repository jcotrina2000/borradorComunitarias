import 'package:explorak5/models/periods.dart';
import 'package:flutter/foundation.dart';
import '../models/grades.dart';

class GradesProvider extends ChangeNotifier {
  static Map<String, List<Grades>> _grades = {};
  Map<String, List<Grades>> get grades => _grades;

  static List<Periods> _periods = [];
  List<Periods> get periods => _periods;

  void setGradesResult(Map<String, List<Grades>> _results) {
    _grades = _results;
    notifyListeners();
  }

  void setPeriods(List<Periods> _results) {
    _periods = _results;
    notifyListeners();
  }

  static Map<String, List<Grades>> get getGrades => _grades;
  static List<Periods> get getPeriods => _periods;

  // void updateList(Grades grade) {
  //   var gradeChosed = _grades["notas"]
  //       .firstWhere((notas) => (notas.id == grade.id), orElse: () => null);
  //   if (gradeChosed == null) {
  //     _grades["notas"].add(grade);
  //   }
  //   for (Grades nota in _grades["notas"]) {
  //     if (grade.id == nota.id && grade.currentScore != nota.currentScore) {
  //       nota.currentScore = grade.currentScore;
  //     }
  //   }
  //   notifyListeners();
  // }
}
