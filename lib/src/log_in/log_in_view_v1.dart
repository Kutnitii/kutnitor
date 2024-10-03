import 'package:flutter/material.dart';
import 'package:kutnitor/src/article/articleView.dart';
import 'package:kutnitor/src/log_in/log_in_service.dart';

import 'log_in_controller.dart';

class LogInView extends StatefulWidget {
  const LogInView({super.key});

  static const String routeName = '/login';

  @override
  State<LogInView> createState() => _LogInView();
}

class _LogInView extends State<LogInView> {
  bool obscurePassword = true;
  late final LogInController logInController;

  @override
  void initState() {
    logInController = LogInController(LogInService());
    super.initState();
  }

  InputBorder myBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: BorderSide.none
  );

  TextFormField usernameWidget() {
    return TextFormField(
      controller: logInController.usernameController,
      decoration: InputDecoration(
        fillColor: Colors.grey.shade300,
        filled: true,
        labelText: 'Your Username',
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: myBorder,
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) => value!.isEmpty ? 'Please enter your username' : null,
    );
  }

  Widget hideShowButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.grey.shade200
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(obscurePassword ? 'SHOW' : 'HIDE',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade500
          )
        )
      ),
    );
  }

  Widget passwordWidget() {
    return TextFormField(
      controller: logInController.passwordController,
      decoration: InputDecoration(
        fillColor: Colors.grey.shade300,
        filled: true,
        labelText: 'Your Password',
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: myBorder,
        suffixIcon: TextButton(
          onPressed: () => setState(() => obscurePassword = !obscurePassword),
          child: hideShowButton(),
        ),
      ),
      obscureText: obscurePassword,
      validator: (value) => value!.isEmpty ? 'Please enter your password' : null,
    );
  }

  Widget logInWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.green, Colors.greenAccent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter
          ),
          borderRadius: BorderRadius.circular(36)
        ),
        child: ElevatedButton(
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white
          ),
          onPressed: () async => {
            if (await logInController.logIn(context)) Navigator.restorablePushNamed(context, ArticleView.routeName)
          },
          child: const Text(
            'SIGN IN',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 2
            )
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Reviewer'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          height: 400,
          child: Card(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: logInController.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    usernameWidget(),
                    const SizedBox(height: 16),
                    passwordWidget(),
                    const SizedBox(height: 8),
                    logInWidget(),
                    const Expanded(child: SizedBox(height: 16)),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'KUTNITI  FOUNDATION',
                        style: TextStyle(fontSize: 11, letterSpacing: 2)
                      )
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}