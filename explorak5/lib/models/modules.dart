class Modules {
  final int id;
  final String workState;
  final String position;
  final String name;
  final String unlockAt;
  final List<int> prerequisiteModuleIds;
  final String state;
  final String published;

  Modules({
    required this.id,
    required this.workState,
    required this.position,
    required this.name,
    required this.unlockAt,
    required this.prerequisiteModuleIds,
    required this.state,
    required this.published,
  });

  static Modules fromJson(Map<String, dynamic> json) {
    if (json["submission"]["score"] == null) {
      json["submission"]["score"] = 0.0;
    }
    return Modules(
      id: json["id"],
      workState: json["work_state"],
      position: json["position"],
      name: json["name"],
      unlockAt: json["unlock_at"],
      prerequisiteModuleIds: json["prerequisite_module_ids"],
      state: json["state"],
      published: json["published"],
    );
  }
}
