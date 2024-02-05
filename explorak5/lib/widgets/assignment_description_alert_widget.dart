import 'package:flutter/material.dart';
import 'package:explorak5/screens/constants.dart';
import 'package:html/parser.dart';

//Alerta emergente con descripcion de la tarea
class AssignmentDescriptionAlert extends StatelessWidget {
  final assignment;

  AssignmentDescriptionAlert({this.assignment});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        assignment.name != null ? assignment.name : "Sin nombre",
        overflow: TextOverflow.clip,
        textAlign: TextAlign.left,
        style: CARD_TITLE_STYLE,
      ),
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              //Se pasea el string, descripcion es texto html
              assignment.description != null
                  ? _parseHtmlString(assignment.description)
                  : "Sin descripción",
              overflow: TextOverflow.clip,
              textAlign: TextAlign.left,
              style: ALERT_ACTION_STYLE,
            ),
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

  //Devuelve string sin etiquetas html
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;
    return parsedString;
  }
}
