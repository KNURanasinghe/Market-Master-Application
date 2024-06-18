import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token = '';
  bool get isAuth => _token.isNotEmpty;

  Future<Map<String, dynamic>> signup(Map<String, dynamic> userData) async {
    final url = Uri.parse(
        'http://192.168.8.159:3000/api/users'); // Replace with your backend URL

    try {
      final response = await http.post(
        url,
        body: json.encode(userData),
        headers: {'Content-Type': 'application/json'},
      );
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        notifyListeners();
        return responseData;
      }
      return {"message": responseData['message']};
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login(Map<String, dynamic> userData) async {
    final url = Uri.parse(
        'http://192.168.8.159:3000/api/users/login'); // Replace with your backend URL

    try {
      final response = await http.post(
        url,
        body: json.encode(userData),
        headers: {'Content-Type': 'application/json'},
      );
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _token = responseData['token'];
        print(_token);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token);
        notifyListeners();
        return responseData;
      } else {
        return {"message": responseData['message']};
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _token = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) {
      return;
    }
    _token = prefs.getString('token') ?? '';
    notifyListeners();
  }
}
