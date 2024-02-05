import 'package:explorak5/screens/webview_oauth_screen.dart';
import 'package:flutter/material.dart';
import 'package:explorak5/screens/constants.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/login-background.png"),
                      fit: BoxFit.fill),
                ),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white.withOpacity(0.8),
                    child: Center(
                        child: Padding(
                      padding: PADDING_LARGE,
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
                          Text(
                            "¡Bienvenidos!",
                            style: LOGIN_WELCOME_STYLE,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: THEME_COLOR),
                            // shape: ROUNDED_CORNERS_SHAPE,
                            child: Padding(
                                padding: PADDING_SMALL,
                                child: Text(
                                  "Iniciar Sesión",
                                  style: BUTTON_TEXT_STYLE,
                                )),
                            onPressed: () => {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => WebviewOauthScreen()))
                            },
                          ),
                        ],
                      ),
                    ))))));
  }
}
