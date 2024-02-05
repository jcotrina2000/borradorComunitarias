import 'package:explorak5/screens/courses_screen.dart';
import 'package:explorak5/services/authentication_client.dart';
import 'package:explorak5/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:explorak5/screens/constants.dart';
import 'package:get_it/get_it.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({required Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _authenticationClient = GetIt.instance<AuthenticationClient>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _checkLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/login-background.png"),
                  fit: BoxFit.fill),
            ),
            child: SafeArea(
                child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Explora K5",
                    style: LOGIN_WELCOME_STYLE,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Image(
                    image: AssetImage("assets/images/explora-logo.png"),
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(child: CircularProgressIndicator()),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ))));
  }

  //Verificar sesion activa
  Future<void> _checkLogin() async {
    final userData = await _authenticationClient.userData;
    if (userData == null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
      return;
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => CoursesScreen(key: UniqueKey())));
    }
  }
}
