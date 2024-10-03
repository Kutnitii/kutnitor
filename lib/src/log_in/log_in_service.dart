// ignore: implementation_imports
import 'package:http/src/response.dart';

import '../utils/http_client.dart';

class LogInService {
  void updateToken(String token) {
    HttpClient().updateToken(token);
  }
  
  Future<Response> retreiveToken(String username, String password)
  async {
    return await HttpClient().post('/login', {
      'user_id': username,
      'password': password,
    });
  }
}