import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountsProvider with ChangeNotifier {
  String _token;
  String get token => _token;
  bool get isCustomer => _token != null;

  AccountsProvider(this._token) {
    init();
  }

  void signIn(String token) {
    _token = token;
    notifyListeners();
  }

  void signOff() {
    _token = '';
    notifyListeners();
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      _token = prefs.getString('customer')!;
    } catch (e) {
      _token = '';
    }
  }
}