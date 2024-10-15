import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kutnitor/src/article/web_view_stack.dart';
import 'package:kutnitor/src/settings/settings_view.dart';
import 'package:kutnitor/src/utils/http_client.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleView extends StatefulWidget {
  const ArticleView({super.key});

  static const String routeName = '/article';

  @override
  State<ArticleView> createState() => _ArticleView();
}

class _ArticleView extends State<ArticleView> {
  final WebViewController controller = WebViewController();

  int _articleId = 0;
  List<String> _tags = List.empty();
  
  int _prevArticleId = 0;
  List<String> _prevTags = List.empty();

  Future<String> getNewMedia() {
    return HttpClient().get('/review').then((response) {
      Map<String, dynamic> decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        setState(() {
          _prevArticleId = _articleId;
          _prevTags = _tags;
          _articleId = int.parse(decodedResponse.keys.first);
          var tags = decodedResponse[_articleId.toString()]['heuristic_tags'];
          print(decodedResponse);
          print(tags.runtimeType);
          print(tags);
        });
        return "";
      }

      return decodedResponse['error'];
    });
  }

  @override
  void initState() {
    super.initState();
    getNewMedia();
  }

  void sendAndChange(String grade) async {
    HttpClient().post('/rating/$_articleId', {'review': grade,});
    getNewMedia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.logout_outlined),
          onPressed: () {
            HttpClient().removeToken();
            Navigator.pop(context);
          },
        ),
        title: SizedBox(
          height: const Size.fromHeight(kToolbarHeight).height,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(4.0),
            separatorBuilder: (BuildContext context, int index) => const Divider(
              indent: 4.0,
            ),
            itemCount: _tags.length,
            itemBuilder:(BuildContext context, int index) {
              return ElevatedButton(
                onPressed: () {},
                child: Text(_tags[index]),
              );
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.replay),
            onPressed: () {
              controller.reload();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.restorablePushNamed(context, SettingsView.routeName)
          ),
        ],
      ),
      body: WebViewStack(controller: controller),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <FloatingActionButton>[
          FloatingActionButton(
            heroTag: 'UndoButton',
            onPressed: () {},
            tooltip: 'Undo',
            child: const Icon(Icons.undo),
          ),
          FloatingActionButton(
            heroTag: 'PositiveButton',
            onPressed: () => sendAndChange('Good'),
            tooltip: 'Positive media',
            child: const Icon(Icons.thumb_up),
          ),
          FloatingActionButton(
            heroTag: 'NeutralButton',
            onPressed: () => sendAndChange('Neutral'),
            tooltip: 'Neutral media',
            child: const Icon(Icons.sentiment_neutral),
          ),
          FloatingActionButton(
            heroTag: 'NegativeButton',
            onPressed: () => sendAndChange('Bad'),
            tooltip: 'Negative media',
            child: const Icon(Icons.thumb_down),
          ),
        ] 
      ),
    );
  }
}