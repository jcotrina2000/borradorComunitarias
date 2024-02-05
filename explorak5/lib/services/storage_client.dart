import 'package:explorak5/models/notificacion.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageClient {
  static SharedPreferences? pref;
  static String keyNoti = 'notification';

  static Future init() async => pref = await SharedPreferences.getInstance();

  static Future<void> writeLocalNoti(Notificacion notification) async {
    pref = await SharedPreferences.getInstance();
    if (!pref!.containsKey(keyNoti) || pref!.getString(keyNoti) == null) {
      String encodedData = Notificacion.encode([notification]);
      await pref!.setString(keyNoti, encodedData);
    } else if (pref!.getString(keyNoti) != null) {
      String listNoti = pref!.getString(keyNoti)!;
      String encodedData = Notificacion.encode([notification]);
      String startStr = listNoti.substring(0, listNoti.length - 1);
      String endStr = encodedData.substring(1);
      await pref!.setString(keyNoti, startStr + "," + endStr);
    }
  }

  static Future<List<Notificacion>> readLocalNoti() async {
    pref = await SharedPreferences.getInstance();
    String listNoti = pref!.getString(keyNoti)!;
    final List<Notificacion> decodedData = Notificacion.decode(listNoti);
    return decodedData;
  }
}
