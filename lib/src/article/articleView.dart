import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kutnitor/src/article/web_view_stack.dart';
import 'package:kutnitor/src/utils/http_client.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'navigation_controller.dart';
import '../settings/settings_controller.dart';
import '../settings/settings_view.dart';
import '../utils/fancy_floating_button.dart';

class ArticleView extends StatefulWidget {
  const ArticleView({super.key, required this.settingsController});

  static const String routeName = '/article';

  final SettingsController settingsController;

  @override
  State<ArticleView> createState() => _ArticleView();
}

class _ArticleView extends State<ArticleView> {
  late final WebViewController controller;

  int _articleId = 0;

  @override
  void initState() {
    super.initState();
    controller = WebViewController();
  }

  void sendAndChange(String grade) async {
    HttpClient().post('/rating/$_articleId', {'review': grade,});
    var response = await HttpClient().get('/review');
    Map<String, dynamic> decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    setState(() {
      _articleId = int.parse(decodedResponse.keys.first);
      controller.loadRequest(
        Uri.parse(decodedResponse[_articleId.toString()]['url']),
      );
    });
  }

  FloatingActionButton positive() {
    return FloatingActionButton(
      onPressed: () => sendAndChange('Good'),
      tooltip: 'Positive media',
      child: const Icon(Icons.thumb_up),
    );
  }

  FloatingActionButton neutral() {
    return FloatingActionButton(
      onPressed: () => sendAndChange('Neutral'),
      tooltip: 'Neutral media',
      child: const Icon(Icons.sentiment_neutral),
    );
  }

  FloatingActionButton negative() {
    return FloatingActionButton(
      onPressed: () => sendAndChange('Bad'),
      tooltip: 'Negative media',
      child: const Icon(Icons.thumb_down),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: const Text('Articles Reviewer'),
        actions: [
          NavigationControls(controller: controller),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => SettingsView(controller: widget.settingsController),
          )
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25)
          )
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4)
        ),
        child: Scaffold(
          body: WebViewStack(controller: controller),
          floatingActionButton: FancyFloatingButton(controller: controller),
        )
      ),
      bottomNavigationBar: AppBar(
        actions: <Widget>[
          positive(),
          neutral(),
          negative(),
        ]
      ),
    );
  }
}