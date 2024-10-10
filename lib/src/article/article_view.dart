import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kutnitor/src/utils/http_client.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'article_bar.dart';

class ArticleView extends StatefulWidget {
  const ArticleView({super.key});

  static const String routeName = '/article';

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

  @override
  Widget build(BuildContext context) {
    final List<String> tags = [
      "Spain", "India", "Space", "Competitive", "Alliance", "Ananas",
      "Mango", "Changria", "Ariane", "Navrati", "Geometry", "Test",
    ];
    return Scaffold(
      appBar: ArticleTopBar(tags: tags),
      body: WebViewWidget(controller: controller),
      floatingActionButton: const ArticleBottomButtons(),
    );
  }
}