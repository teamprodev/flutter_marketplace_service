library api;

import 'dart:convert';

import 'package:flutter_marketplace_service/models/login_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static Future<HttpResult> post(url, data) async {
    try {
      final dynamic headers = await _getReqHeader();
      http.Response res = await http.post(url, body: data, headers: headers);
      return _result(res);
    } catch (_) {
      return _result({});
    }
  }

  static Future<HttpResult> put(url, data) async {
    try {
      final dynamic headers = await _getReqHeader();
      http.Response res = await http.put(url, body: data, headers: headers);
      return _result(res);
    } catch (_) {
      return _result({});
    }
  }

  static Future<HttpResult> delete(url) async {
    try {
      final dynamic headers = await _getReqHeader();
      http.Response res = await http.delete(url, headers: headers);
      return _result(res);
    } catch (_) {
      return _result({});
    }
  }

  static Future<HttpResult> get(url) async {
    try {
      final dynamic headers = await _getReqHeader();
      http.Response res = await http.get(url, headers: headers);
      return _result(res);
    } catch (_) {
      return _result({});
    }
  }

  static HttpResult _result(response) {
    dynamic result;
    int status = response.statusCode ?? 404;

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      result = response.body;
      return HttpResult(true, result, status);
    } else {
      return HttpResult(false, "", status);
    }
  }

  static _getReqHeader() async {
    final prefs = await SharedPreferences.getInstance();
    final String tokenString = prefs.getString('token');
    String token;
    if (tokenString != null) {
      var userData = LoginResponseModel.fromJson(json.decode(tokenString));
      token = "bearer " + userData.accessToken;
    }

    final Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": token
    };

    return headers;
  }
}

class HttpResult {
  final bool isSuccess;
  final int status;
  final String result;

  HttpResult(this.isSuccess, this.result, this.status);
}
