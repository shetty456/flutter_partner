import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const dev = 'http://10.0.2.2:3000/';
const prod = 'https://k6kk3hg2r6.execute-api.ap-south-1.amazonaws.com/dev/';

class Auth with ChangeNotifier {
  String _token = '';
  String _userId = '';
  String _username = '';

  String get isAuth {
    return _token;
  }

  String get userId {
    return _userId;
  }

  String get username {
    return _username;
  }

  Future<void> login(String email, String password) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    final url = Uri.parse('${prod}api/customer/login');

    try {
      final response = await http.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(
          {
            'email': email,
            'password': password,
          },
        ),
      );

      final responseData = jsonDecode(response.body);
      _token = responseData["token"];
      _userId = responseData["customer"]["_id"];
      _username = responseData["customer"]["name"];
      if (kDebugMode) {
        print({
          _token,
          _userId,
          _username,
        });
      }
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final customerData = jsonEncode({
        'token': _token,
        'userId': _userId,
        'username': _username,
      });
      prefs.setString('customerData', customerData);
    } catch (error) {
      rethrow;
    }
  }

  // code to register a customer
  Future<void> register(
    String firstname,
    String lastname,
    String phonenumber,
    String email,
    String password,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    final url = Uri.parse('${prod}api/customer/register');

    try {
      final response = await http.post(
        url,
        headers: requestHeaders,
        body: jsonEncode(
          {
            'firstname': firstname,
            'lastname': lastname,
            'phonenumber': phonenumber,
            'email': email,
            'password': password,
          },
        ),
      );

      final responseData = jsonDecode(response.body);
      _token = responseData["token"];
      _userId = responseData["customer"]["_id"];
      _username = responseData["customer"]["name"];
      if (kDebugMode) {
        print({
          _token,
          _userId,
          _username,
        });
      }
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final customerData = jsonEncode({
        'token': _token,
        'userId': _userId,
        'username': _username,
      });
      prefs.setString('customerData', customerData);
    } catch (error) {
      rethrow;
    }
  }

  // auto login a customer if his credentials are present in sharedprefs
  Future<void> tryAutoLogin() async {
    if (kDebugMode) {
      print('auto login');
    }
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('customerData')) {
      return;
    }

    final userData = prefs.getString('customerData');
    if (kDebugMode) {
      print(userData);
    }
    final extractedUserData = jsonDecode(userData!);

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _username = extractedUserData['username'];
    if (kDebugMode) {
      print('username is: $_username');
    }
    notifyListeners();
  }

  Future<void> logout() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',
    };

    final url = Uri.parse('${prod}api/customer/logout');
    try {
      final response = await http.post(
        url,
        headers: requestHeaders,
        body: jsonEncode({
          'token': _token,
        }),
      );

      final responseData = jsonDecode(response.body);
      if (kDebugMode) {
        print(responseData);
      }
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
    } catch (error) {
      rethrow;
    }
  }
}
