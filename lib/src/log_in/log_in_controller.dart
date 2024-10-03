import 'dart:convert';

import 'package:flutter/material.dart';

import 'log_in_service.dart';

class LogInController {
  LogInController(this._logInService);

  final LogInService _logInService;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get usernameController => _usernameController;
  TextEditingController get passwordController => _passwordController;

  Future<bool> logIn(BuildContext context)
  async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(
          'Username or password is empty.'
        )),
      );
      return false;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Processing data')),
    );
    return await _logInService.retreiveToken(_usernameController.text, _passwordController.text)
      .then((response) {
        Map<String, dynamic> decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        if (response.statusCode == 200) {
          _logInService.updateToken(decodedResponse['token']);
          ScaffoldMessenger.of(context).clearSnackBars();
          return true;
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(decodedResponse['error']))
          );
          return false;
        }
      });
  }
}