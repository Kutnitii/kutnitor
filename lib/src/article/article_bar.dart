import 'package:flutter/material.dart';
import 'package:kutnitor/src/log_in/log_in_view.dart';
import 'package:kutnitor/src/settings/settings_view.dart';
import 'package:kutnitor/src/utils/http_client.dart';

class ArticleTopBar extends StatefulWidget implements PreferredSizeWidget {
  const ArticleTopBar({
    super.key,
    required this.tags,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  final List<String> tags;

  @override
  State<ArticleTopBar> createState() => _ArticleTopBar(); 
}

class _ArticleTopBar extends State<ArticleTopBar> {
  _ArticleTopBar();
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.logout_outlined),
        onPressed: () {
          HttpClient().removeToken();
          Navigator.restorablePopAndPushNamed(context, LogInView.routeName);
        },
      ),
      title: SizedBox(
        height: widget.preferredSize.height,
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(4.0),
          separatorBuilder: (BuildContext context, int index) => const Divider(
            indent: 4.0,
          ),
          itemCount: widget.tags.length,
          itemBuilder:(BuildContext context, int index) {
            return ElevatedButton(
              onPressed: () {},
              child: Text(widget.tags[index]),
            );
          },
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => Navigator.restorablePushNamed(context, SettingsView.routeName)
        ),
      ],
    );
  }
}

class ArticleBottomButtons extends StatefulWidget {
  const ArticleBottomButtons({super.key});

  @override
  State<StatefulWidget> createState() => _ArticleBottomButtons();
}

class _ArticleBottomButtons extends State<ArticleBottomButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
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
          onPressed: () {},
          tooltip: 'Positive media',
          child: const Icon(Icons.thumb_up),
        ),
        FloatingActionButton(
          heroTag: 'NeutralButton',
          onPressed: () {},
          tooltip: 'Neutral media',
          child: const Icon(Icons.sentiment_neutral),
        ),
        FloatingActionButton(
          heroTag: 'NegativeButton',
          onPressed: () {},
          tooltip: 'Negative media',
          child: const Icon(Icons.thumb_down),
        ),
      ] 
    );
  }
}