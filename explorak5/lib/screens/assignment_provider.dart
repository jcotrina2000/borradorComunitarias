import 'package:flutter/foundation.dart';
import 'package:explorak5/models/assignment.dart';

class AssignmentProvider extends ChangeNotifier {
  static Map<String, List<Assignment>> _assignments = {
    "toDo": [],
    "submitted": []
  };
  Map<String, List<Assignment>> get assignments => _assignments;

  void setAssignmentResult(Map<String, List<Assignment>> _results) {
    _assignments["toDo"] = _results["toDo"]!;
    _assignments["submitted"] = _results["submitted"]!;
    notifyListeners();
  }

  static List<Assignment> get toDoList => _assignments["toDo"]!;
  static List<Assignment> get submittedList => _assignments["submitted"]!;

  void updateList(int assignId) {
    Assignment assignEnviado =
        _assignments["toDo"]!.firstWhere((assign) => assign.id == assignId);
      assignEnviado.submitted = true;
      _assignments["submitted"]!.add(assignEnviado);
      _assignments["toDo"]!.removeWhere((assign) => assign.id == assignId);
    notifyListeners();
  }
}
