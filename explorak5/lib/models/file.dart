class File {
  final int size;
  final String name;
  final String type;
  File({required this.name,required this.size,required this.type});

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      size: json['size'],
      name: json['name'],
      type: json['type'],
    );
  }
}
