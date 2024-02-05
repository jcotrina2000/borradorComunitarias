import 'package:explorak5/helpers/dependency_injection.dart';
import 'package:explorak5/screens/constants.dart';
import 'package:explorak5/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependecyInjection.initialize();
  runApp(TareasExploraApp());
}

class TareasExploraApp extends StatefulWidget {
  @override
  _TareasExploraAppState createState() => _TareasExploraAppState();
}

class _TareasExploraAppState extends State<TareasExploraApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Explora K5',
        theme: ThemeData(primaryColor: THEME_COLOR, fontFamily: 'Quicksand'),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(key: UniqueKey()));
  }
}
