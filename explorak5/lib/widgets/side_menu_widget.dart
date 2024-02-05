import 'package:explorak5/exp_icons_icons.dart';
import 'package:explorak5/screens/constants.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../screens/courses_screen.dart';
import '../screens/login_screen.dart';
import '../services/authentication_client.dart';

class SideMenu extends StatelessWidget {
  final _authenticationClient = GetIt.instance<AuthenticationClient>();

  @override
  Widget build(BuildContext context) {
    Future<void> _logout() async {
      dynamic userData = await _authenticationClient.userData;
      String token = userData.token;
      await _authenticationClient.deleteSession(token);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(color: PALLETE_BLUE), child: Text("")),
          ListTile(
            leading: Icon(
              ExpIcons.inicio,
              color: PALLETE_BLUE,
            ),
            title: Text('Inicio | Mis materias'),
            onTap: () => {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => CoursesScreen(key: UniqueKey())))
            },
          ),
          ListTile(
            leading: Icon(
              ExpIcons.insert_invitation,
              color: PALLETE_BLUE,
            ),
            title: Text('Calendario'),
            onTap: () => {print("Calendario")},
          ),
          ListTile(
            leading: Icon(
              ExpIcons.email,
              color: PALLETE_BLUE,
            ),
            title: Text('Conversaciones'),
            onTap: () => {print("Conversaciones")},
          ),
          ListTile(
            leading: Icon(
              ExpIcons.import_contacts,
              color: PALLETE_BLUE,
            ),
            title: Text('Agenda'),
            onTap: () => {print("Agenda")},
          ),
          ListTile(
            leading: Icon(
              ExpIcons.exit_to_app,
              color: PALLETE_BLUE,
            ),
            title: Text('Salir'),
            onTap: () => {_logout()},
          ),
        ],
      ),
    );
  }
}
