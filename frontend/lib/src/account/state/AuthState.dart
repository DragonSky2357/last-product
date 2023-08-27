import 'package:flutter/material.dart';

class AuthState extends ChangeNotifier {
  String? _token;
  String? get getToken => _token;
  bool get isLoggedIn => _token != null;

  void login(String token) {
    _token = token;
    notifyListeners();
  }

  void logout() {
    _token = null;

    notifyListeners();
  }
}
