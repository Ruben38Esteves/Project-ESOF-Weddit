import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'WebViewStack.dart';
import 'package:app/Pages/Variables.dart' as global;

class myWebView extends StatefulWidget {
  final Function mySetState;
  late WebViewStack owebViewStack;
  myWebView({required this.mySetState});

  @override
  State<myWebView> createState() => _myWebViewState();
}

class _myWebViewState extends State<myWebView> {

  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse(global.curr_article),
      );
  }

  @override
  Widget build(BuildContext context) {
    widget.owebViewStack = WebViewStack(controller: controller, mySetState: widget.mySetState,);
    return Scaffold(
      body: widget.owebViewStack,       // MODIFY
    );
  }
}
