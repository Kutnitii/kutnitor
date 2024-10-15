import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class HttpClient {
  static final HttpClient _instance = HttpClient._();
  
  final http.Client _client = http.Client();
  static const String _baseUrl = 'http://192.168.1.10:5000';
  String? _token;

  HttpClient._();

  factory HttpClient()
  {
    return _instance;
  }

  void updateToken(String token)
  {
    _token = token;
  }

  void removeToken()
  {
    _token = null;
  }

  Future<bool> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.ethernet)
      || connectivityResult.contains(ConnectivityResult.wifi)
      || connectivityResult.contains(ConnectivityResult.mobile)
      || connectivityResult.contains(ConnectivityResult.vpn)
      || connectivityResult.contains(ConnectivityResult.other);
  }

  Future<http.Response> get(String endpoint) async {
    if (!await checkConnectivity()) {
      return http.Response(jsonEncode({'error': 'No Internet connection'}), 408);
    }

    Map<String, String> headers = {};
    if (_token != null) {
      headers['Authorization'] = _token!;
    }

    try {
      return await _client
        .get(
          Uri.parse(_baseUrl + endpoint),
          headers: headers,
        ).timeout(
          const Duration(seconds: 10),
          onTimeout: () => http.Response(jsonEncode({'error': 'Resquest Timeout'}), 408),
        ).catchError(
          (error) => http.Response(jsonEncode(error), 400)
        );
    } catch (e) {
      return http.Response(jsonEncode({'error': 'Unexpected Network Issue: ${e.toString()}'}), 503);  
    }
  }

  Future<http.Response> post(String endpoint, Object body) async {
    if (!await checkConnectivity()) {
      return http.Response(jsonEncode({'error': 'No Internet connection'}), 408);
    }

    Map<String, String> headers = {};
    if (_token != null) {
      headers['Authorization'] = _token!;
    }

    try {
      return await _client
      .post(
        Uri.parse(_baseUrl + endpoint),
        headers: headers,
        body: body,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => http.Response(jsonEncode({'error': 'Resquest Timeout'}), 408),
      ).catchError(
        (error) => http.Response(jsonEncode(error), 400)
      );
    } catch (e) {
      return http.Response(jsonEncode({'error': 'Unexpected Network Issue: ${e.toString()}'}), 503);
    }
  }
}