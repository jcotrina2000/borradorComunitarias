class Category {
  final int id;
  final String name;
  final double weight;

  Category({required this.id,required this.name,required this.weight});

  static Category fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"],
      name: json["name"],
      weight: json["group_weight"],
    );
  }
}
