import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  bool _isLoginButtonClicked = false;

  bool get isLoginButtonClicked => _isLoginButtonClicked;
  set isLoginButtonClicked(value) {
    _isLoginButtonClicked = value;
    notifyListeners();
  }
}
