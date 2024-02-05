import 'package:flutter/material.dart';
import 'package:explorak5/screens/constants.dart';

//Alerta emergente con seccion de informacion general
class AboutAlert extends StatelessWidget {
  final String imgPath = "assets/images/logos_participantes/";
  final double size = 90;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Acerca de Explora K5",
        style: ALERT_TITLE_STYLE,
        textAlign: TextAlign.center,
      ),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Gestor de tareas para estudiantes en la plataforma Explora K5",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: PALLETE_BLUE),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),
            Padding(
                padding: PADDING_SMALL,
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(imgPath + "800px-UNEMI-logo.jpg"),
                          width: size,
                          height: size,
                        ),
                        Image(
                          image: AssetImage(imgPath + "exploraLOGO.png"),
                          width: size,
                          height: size,
                        ),
                        Image(
                          image: AssetImage(imgPath + "LOGO-REA-V4-01.png"),
                          width: size,
                          height: size,
                        )
                      ]),
                )),
            Padding(
                padding: PADDING_SMALL,
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image:
                              AssetImage(imgPath + "LOGO-DEL-BANCO---SOLO.png"),
                          width: size,
                          height: size,
                        ),
                        Image(
                          image:
                              AssetImage(imgPath + "LOGO-MANUAL_SHAYA-v1.png"),
                          width: size,
                          height: size,
                        ),
                        Image(
                          image: AssetImage(imgPath +
                              "logo-ministerio-educacion-foros-ecuador.png"),
                          width: size,
                          height: size,
                        )
                      ]),
                )),
            Padding(
                padding: PADDING_SMALL,
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(imgPath +
                              "logo-mision-alianza logo 2 ESP CMYK.png"),
                          width: size,
                          height: size,
                        ),
                        Image(
                          image:
                              AssetImage(imgPath + "Logos-sociedad-T-02.png"),
                          width: size,
                          height: size,
                        ),
                        Image(
                          image: AssetImage(imgPath + "schlumberger-logo.png"),
                          width: size,
                          height: size,
                        )
                      ]),
                )),
            Padding(
                padding: PADDING_SMALL,
                child: Align(
                    alignment: Alignment.center,
                    child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage(
                                imgPath + "Universidad-Casa-Grande.png"),
                            width: size,
                            height: size,
                          ),
                        ])))
          ]),
      actions: [
        TextButton(
            child: Text("OK", style: ALERT_ACTION_STYLE),
            onPressed: () {
              Navigator.of(context).pop();
            })
      ],
    );
  }
}
