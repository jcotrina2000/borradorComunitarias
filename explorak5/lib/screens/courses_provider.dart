import 'package:explorak5/models/courses.dart';
import 'package:flutter/foundation.dart';

class CoursesProvider extends ChangeNotifier {
  static Map<String, List<Course>> _courses = {"available": []};
  Map<String, List<Course>> get courses => _courses;
  List<dynamic> colores = [];

  static List<Course> get availableCourses => _courses["available"]!;

  void setCoursesResult(Map<String, List<Course>> _results) {
    _courses["available"] = _results["available"]!;
    notifyListeners();
  }

  List<dynamic> get availableColors => colores;

  void setColoresResult(List<dynamic> coloresList) {
    colores = coloresList;
    notifyListeners();
  }
}
