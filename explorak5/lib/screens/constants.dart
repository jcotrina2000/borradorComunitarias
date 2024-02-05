import 'package:flutter/material.dart';

//UNIVERSAL
const PALLETE_BLUE = Colors.blue;
const PALLETE_RED = Color(0xFFFF3C38);
const PALLETE_GREEN = Color(0xFF33CA7F);
const PALLETE_GRAY_3 = Color.fromARGB(255, 230, 230, 230);
const THEME_COLOR = PALLETE_BLUE;
const BUTTON_PADDING = EdgeInsets.all(1.0);
const PADDING_SMALL = EdgeInsets.all(5.0);
const PADDING_MEDIUM = EdgeInsets.all(5.0);
const PADDING_LARGE = EdgeInsets.all(10.0);
const BORDER_RADIUS = BorderRadius.all(Radius.circular(10));
const BUTTON_TEXT_STYLE =
    TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);
const ROUNDED_CORNERS_SHAPE = RoundedRectangleBorder(
    borderRadius: BORDER_RADIUS, side: BorderSide(color: Colors.transparent));

//LOGIN SCREEN
const LOGIN_WELCOME_STYLE =
    TextStyle(color: PALLETE_RED, fontSize: 35, fontWeight: FontWeight.bold);

//ASSIGNMENTS SCREEN
const APPBAR_TITLE_STYLE =
    TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);
const NO_ASSIGNMENTS_TEXT_STYLE =
    TextStyle(color: PALLETE_RED, fontSize: 18, fontWeight: FontWeight.bold);
const LOGOUT_TEXT_STYLE =
    TextStyle(color: PALLETE_RED, fontSize: 20, fontWeight: FontWeight.bold);
const LIST_TITLE_STYLE =
    TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);
const SCREEN_HEADER =
    TextStyle(color: PALLETE_RED, fontSize: 20, fontWeight: FontWeight.bold);
const SCREEN_MENU_HEADER =
    TextStyle(color: PALLETE_BLUE, fontSize: 20, fontWeight: FontWeight.bold);
const TABLE_HEADER =
    TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold);
const TABLE_CONTENT =
    TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold);

//TAREAS CARD WIDGET
const CARD_ELEVATION = 5.0;
const CARD_TITLE_COURSE_STYLE =
    TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold);
const CARD_ASSIGNMENT_STYLE =
    TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold);
const CARD_TITLE_STYLE =
    TextStyle(color: PALLETE_RED, fontSize: 15, fontWeight: FontWeight.bold);
const CARD_DATA_STYLE =
    TextStyle(color: PALLETE_BLUE, fontSize: 15, fontWeight: FontWeight.bold);
const CARD_LOCKED_ASSIGNMENT =
    TextStyle(color: PALLETE_GRAY_3, fontWeight: FontWeight.w600);
const CARD_BUTTON_STYLE =
    TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold);

//TAREAS DIALOG WIDGET
const ALERT_ACTION_STYLE =
    TextStyle(color: PALLETE_BLUE, fontSize: 15, fontWeight: FontWeight.bold);
const ALERT_TITLE_STYLE =
    TextStyle(color: PALLETE_BLUE, fontSize: 18, fontWeight: FontWeight.bold);
const CARD_ASSIGNMENT_PADDING =
    EdgeInsets.symmetric(horizontal: 5, vertical: 5);

//FILE PICKER SCREEN
const FILE_PICKER_BUTTON_STYLE =
    TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold);
const FILE_PICKER_TEXT_STYLE =
    TextStyle(color: PALLETE_BLUE, fontSize: 15, fontWeight: FontWeight.normal);

//TAREAS IMAGE
const DEFAULT_IMAGE = 'http://192.168.3.245/images/images_k5/PI001.png';

//TEXT INFORMATION
const TEXT_INFORMATION =
    TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal);
