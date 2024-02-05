class Periods {
  final int id;
  final String periodGroupId;
  final double weight;
  final String title;
  final bool isClosed;

  Periods(
      {required this.id,required this.periodGroupId,required this.weight,required this.title,required this.isClosed});

  static Periods fromJson(Map<String, dynamic> json) {
    return Periods(
      id: int.parse(json["id"]),
      periodGroupId: json["grading_period_group_id"],
      weight: json["weight"],
      title: json["title"],
      isClosed: json["is_closed"],
    );
  }
}
