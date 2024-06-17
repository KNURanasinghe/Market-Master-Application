// auth_provider.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expiryDate;

  bool get isAuth {
    return _token != null;
  }

  Future<void> signup(String username, String email, String password,
      List<String> roles, Map<String, String> additionalData) async {
    final url = Uri.parse('http://localhost:3000/api/users');
    final response = await http.post(
      url,
      body: json.encode({
        'name': username,
        'email': email,
        'password': password,
        'roles': roles,
        'additionalData': additionalData,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      _token = responseData['token'];
      _userId = responseData['userId'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(responseData['expiresIn'])),
      );
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', _token!);
    } else {
      throw Exception(responseData['error']);
    }
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse('http://localhost:3000/api/users/login');
    final response = await http.post(
      url,
      body: json.encode({
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      _token = responseData['token'];
      _userId = responseData['userId'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(responseData['expiresIn'])),
      );
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', _token!);
    } else {
      throw Exception(responseData['error']);
    }
    await Future.delayed(const Duration(seconds: 2));
    // If the signup fails, throw an error
    throw Exception('Signup failed');
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }
}
