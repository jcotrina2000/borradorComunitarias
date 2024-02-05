class CourseColor {
  final String color;

  CourseColor({required this.color});

  static CourseColor fromJson(Map<String, dynamic> json, String key) {
    return CourseColor(color: json[key]);
  }
}
