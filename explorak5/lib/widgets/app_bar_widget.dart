import 'package:explorak5/api/school_logo_api.dart';
import 'package:explorak5/screens/constants.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/authentication_client.dart';
import 'about_alert_widget.dart';

class AppBarExplora extends StatefulWidget implements PreferredSizeWidget {
  AppBarExplora({
    required Key key,
  }) : super(key: key);

  @override
  _AppBarExplora createState() => _AppBarExplora();

  @override
  final Size preferredSize = Size.fromHeight(kToolbarHeight);
}

class _AppBarExplora extends State<AppBarExplora> {
  late String username;
  String avatar_url = DEFAULT_IMAGE;
  String schoolLogo = DEFAULT_IMAGE;
  _AppBarExplora();

  final _authenticationClient = GetIt.instance<AuthenticationClient>();
  final _schoolLogo = GetIt.instance<SchoolLogoAPI>();

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getSchoolLogo();
      _getUsername();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Image.asset("assets/images/explora-logo.png"),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      title: SizedBox(
        height: kToolbarHeight,
        child: Image.network(schoolLogo),
      ),
      centerTitle: true,
      actions: [
        PopupMenuButton<String>(
          onSelected: handleMenuClick,
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: "username",
              child: Text(username),
              enabled: false,
            ),
            PopupMenuItem(
              value: "about",
              child: Text("Acerca de Explora K5", style: LOGOUT_TEXT_STYLE),
            ),
          ],
          child: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(avatar_url),
            backgroundColor: Colors.white,
          ),
        )
      ],
    );
  }

  void handleMenuClick(String value) {
    switch (value) {
      case 'about':
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AboutAlert();
            });
        return;
    }
  }

  Future<void> _getUsername() async {
    dynamic userData = await _authenticationClient.userData;
    if (mounted) {
      setState(() {
        username = userData.username;
        avatar_url = userData.avatar;
      });
    }
  }

  Future<void> _getSchoolLogo() async {
    var response = await _schoolLogo.getSchoolLogo();
      String iterableJSON =
          (response.data).split("ic-brand-right-sidebar-logo:")[1];
      String logoUrl = iterableJSON.substring(4, 130).split("'")[1];
      print(logoUrl);
      setState(() {
        schoolLogo = logoUrl;
      });
  }
}
