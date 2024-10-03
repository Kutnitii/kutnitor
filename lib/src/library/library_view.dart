import 'package:flutter/material.dart';
import 'package:kutnitor/src/article/articleView.dart';
import '../article/article.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key, });

  static const String routeName = '/library';

  

  @override
  State<LibraryView> createState() => _LibraryView();
}

class _LibraryView extends State<LibraryView> {

  late final List<Article> articles;
  late final List<String> countries;

  @override
  void initState() {
    articles = List<Article>.generate(100, (i) => Article(i + 1, "Title ${i + 1}"));
    countries = List<String>.generate(100, (i) => "Country ${i + 1}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Selection Menu"),
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (BuildContext context, int index) {
                final String countryName = countries[index];
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.black),
                  ),
                  title: Text(countryName),
                  leading: const CircleAvatar(
                    foregroundImage: AssetImage('assets/images/flutter_logo.png'),
                  ),
                  onTap: () {},
                );
              }
            )
          ),
          Expanded(
            flex: 4,
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (BuildContext context, int index) {
                final item = articles[index];
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.black),
                  ),
                  title: Text('Article ${item.url}'),
                  onTap: () => Navigator.restorablePushNamed(context, ArticleView.routeName),
                );
              }
            )
          )
        ]
      ),
    );
  }
}