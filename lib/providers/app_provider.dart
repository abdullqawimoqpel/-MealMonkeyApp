import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  bool _isLoading = false;
  String _currentScreen = 'splash';
  Map<String, dynamic>? _currentUser;

  bool get isLoading => _isLoading;
  String get currentScreen => _currentScreen;
  Map<String, dynamic>? get currentUser => _currentUser;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setCurrentScreen(String screen) {
    _currentScreen = screen;
    notifyListeners();
  }

  void setCurrentUser(Map<String, dynamic>? user) {
    _currentUser = user;
    notifyListeners();
  }

  bool get isLoggedIn => _currentUser != null;

  void logout() {
    _currentUser = null;
    _currentScreen = 'login';
    notifyListeners();
  }
}

