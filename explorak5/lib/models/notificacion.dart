import 'dart:convert';

class Notificacion {
  int id;
  String title;
  String body;
  String assignmentId;

  Notificacion({required this.id, required this.title,required this.body,required this.assignmentId});

  factory Notificacion.fromJson(Map<String, dynamic> json) {
    String assign = '';
    if (json['url'] != null) {
      assign = (json['url'].split('/'))[6];
    }
    return Notificacion(
        id: json['id'],
        title: json['title'],
        body: json['message'],
        assignmentId: assign);
  }

  static Map<String, dynamic> toMap(Notificacion noti) => {
        'id': noti.id,
        'title': noti.title,
        'body': noti.body,
        'assignentId': noti.assignmentId,
      };

  static String encode(List<Notificacion> notis) => json.encode(
        notis
            .map<Map<String, dynamic>>((noti) => Notificacion.toMap(noti))
            .toList(),
      );

  static List<Notificacion> decode(String notis) =>
      (json.decode(notis) as List<dynamic>)
          .map<Notificacion>((item) => Notificacion.fromJson(item))
          .toList();
}
