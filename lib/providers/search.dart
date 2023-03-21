import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const dev = 'http://10.0.2.2:3000/';
const prod = 'https://k6kk3hg2r6.execute-api.ap-south-1.amazonaws.com/dev/';

class Search with ChangeNotifier {
  final String token;
  final String username;
  final String userId;
  Search(
    this.token,
    this.username,
    this.userId,
  );

  bool _loading = false;

  bool get loading {
    return _loading;
  }

  List<dynamic> _data = [];

  List<dynamic> get result {
    return _data;
  }

  Map<String, dynamic> findById(String id) {
    return _data.firstWhere(
      (element) => element["_id"] == id,
    );
  }

  Future<void> searchsalons(String query) async {
    _loading = true;
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final url = Uri.parse('${prod}api/customer/search?query=$query');

    try {
      final response = await http.get(url, headers: requestHeaders);

      final responseData = jsonDecode(response.body);
      _data = responseData["salons"];
      _loading = false;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
