import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:explorak5/api/authentication_api.dart';
import 'package:explorak5/helpers/http_constants.dart';
import 'package:explorak5/models/session.dart';
import 'package:explorak5/models/user_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../api/user_api.dart';

class AuthenticationClient {
  final FlutterSecureStorage _secureStorage;
  final AuthenticationAPI _authenticationAPI;
  static final _userAPI = GetIt.instance<UserAPI>();

  AuthenticationClient(this._secureStorage, this._authenticationAPI);

  Future<dynamic> get userData async {
    final data = await _secureStorage.read(key: "session");
    if (data != null) {
      final session = Session.fromJson(jsonDecode(data));
      final DateTime currentDate = DateTime.now();
      final DateTime createdAt = session.createdAt;
      final int expiresIn = session.expiresIn;
      final int diff = currentDate.difference(createdAt).inSeconds;
      //Si le queda menos de 10 min de vida al token se refresca. Se puede ajustar.
      if (expiresIn - diff >= 600) {
        return session;
      } else {
        FormData formData = FormData.fromMap({
          "grant_type": "refresh_token",
          "client_id": CLIENT_ID,
          "client_secret": CLIENT_SECRET,
          "redirect_uri": REDIRECT_URI,
          "refresh_token": session.refreshToken
        });
        final response = await _authenticationAPI.refreshToken(formData);
        if (response.data != null) {
          final newSessionData = json.decode(response.data);
          final jsonImage =
              await _userAPI.getUserData(newSessionData["access_token"]);
          newSessionData["user_image"] = jsonImage.data["avatar_url"];
          newSessionData["refresh_token"] = session.refreshToken;
          print(newSessionData);
          final newUserData = UserData.fromJson(newSessionData);
          await this.saveSession(newUserData);
          return newUserData;
        }
        return null;
      }
    }
    return null;
  }

  Future<void> saveSession(UserData userData) async {
    final Session session = Session(
        token: userData.token,
        username: userData.username,
        refreshToken: userData.refreshToken,
        expiresIn: userData.expiresIn,
        avatar: userData.avatar,
        createdAt: DateTime.now());

    final data = jsonEncode(session.toJson());
    await _secureStorage.write(key: "session", value: data);
  }

  Future<void> deleteSession(String token) async {
    await _authenticationAPI.deleteToken(token);
    await _secureStorage.deleteAll();
  }
}
