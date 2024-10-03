import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'http_client.dart';

class FancyFloatingButton extends StatefulWidget {
  const FancyFloatingButton({required this.controller,super.key});

  final WebViewController controller;

  @override
  State<FancyFloatingButton> createState() => _FancyFloatingButton();
}

class _FancyFloatingButton extends State<FancyFloatingButton>
  with SingleTickerProviderStateMixin {
  bool isOpened = false;
  late AnimationController _animationController;
  late Animation<Color?> _buttonColor;
  late Animation<double> _animatedIcon;
  late Animation<double> _translatedButton;
  final Curve _curve = Curves.easeOut;
  final double _translationHeight = 56.0;

  int _articleId = 0;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addListener(() {
      setState(() {});
    });
    _animatedIcon = Tween<double>(
      begin: 0.0,
      end: 1.0
    ).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translatedButton = Tween<double>(
      begin: _translationHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.8,
        curve: _curve
      ),
    ));
    HttpClient().get('/review')
      .then((response) {
        Map<String, dynamic> decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        setState(() => _articleId = int.parse(decodedResponse.keys.first));
        widget.controller.loadRequest(
          Uri.parse(decodedResponse[_articleId.toString()]['url']),
        );
      });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  void sendAndChange(String grade) async {
    HttpClient().post('/rating/$_articleId', {'review': grade,});
    var response = await HttpClient().get('/review');
    Map<String, dynamic> decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    setState(() {
      _articleId = int.parse(decodedResponse.keys.first);
      widget.controller.loadRequest(
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

  FloatingActionButton toggle() {
    return FloatingActionButton(
      backgroundColor: _buttonColor.value,
      onPressed: animate,
      tooltip: 'Toggle',
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animatedIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translatedButton.value * 3,
            0.0
          ),
          child: positive(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translatedButton.value * 2,
            0.0
            ),
          child: neutral(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translatedButton.value,
            0.0
          ),
          child: negative()
        ),
        toggle(),
      ],
    );
  }
}

