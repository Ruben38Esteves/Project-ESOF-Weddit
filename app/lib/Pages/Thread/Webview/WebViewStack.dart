import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:app/Pages/Variables.dart' as global;

class WebViewStack extends StatefulWidget {
  final Function mySetState;
  const WebViewStack({required this.controller, required this.mySetState, super.key});

  final WebViewController controller;

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  var loadingPercentage = 0;

  Future<NavigationDecision> myOnNavigationRequest (navigation) async {
    global.curr_article = Uri.parse(navigation.url).toString();
    final host = Uri.parse(navigation.url).host;
    final myurl = navigation.url;
    if ((myurl.substring(0,32) != 'https://en.m.wikipedia.org/wiki/' || myurl.substring(27).contains(':') || myurl.substring(27).contains('?') || myurl.substring(27).contains('%')) && !myurl.contains('Search&search=') && !myurl.contains('Special%3ASearch')) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 800),
        content: Text(
          'Blocking navigation to $host',
          ),
        ),
      );
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  @override
  void initState() {
    super.initState();
    widget.controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
        // Add from here...
        onNavigationRequest: (navigation) {
          return myOnNavigationRequest(navigation).then((value) {
            widget.mySetState();
            return value;
          });
        },
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(
          controller: widget.controller,
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
          ),
      ],
    );
  }
}