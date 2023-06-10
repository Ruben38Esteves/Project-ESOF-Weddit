import 'package:app/Pages/myBottomBar.dart';
import 'package:flutter/material.dart';
import 'package:app/Pages/Variables.dart' as global;
import 'package:app/Pages/Thread/Webview/WebView.dart';
import 'API.dart';


class thread extends StatefulWidget{

  thread();

  @override
  State<thread> createState() => _threadState();
}

class _threadState extends State<thread> {

  late myWebView _myWebView;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _myWebView = myWebView(mySetState: () {setState(() {});},);
    global.currPage = 0;
    return Scaffold(

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  _myWebView,
                  Column(
                    children: [
                      Expanded(child: Container(),),
                      Row(
                        children: [
                          Expanded(child: Container()),
                          Column(
                            children: [
                              GestureDetector(
                                child: Icon(
                                  Icons.question_mark,
                                  size: global.total_height * 0.045,
                                ),
                                onTap: () async {
                                  global.curr_article = await fetchRandom();
                                  setState(() {_myWebView.owebViewStack.controller.loadRequest(Uri.parse(global.curr_article),);});
                                },
                              ),
                              SizedBox(
                                height: global.total_height * 0.005,
                              ),
                              if(global.curr_article.contains('Search&search=') || global.curr_article.contains('Special%3ASearch')) ...[]
                              else if(global.curr_user.saved.contains(global.curr_article)) ... [
                                GestureDetector(
                                  child: Icon(
                                    Icons.star,
                                    size: global.total_height * 0.05,
                                  ),
                                  onTap: () {
                                    global.curr_user.saved.remove(global.curr_article);
                                    global.globalFirestoreUpdate();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          duration: Duration(milliseconds: 800),
                                          content: Text(
                                            "Unsaved the article"
                                        )
                                      ),
                                    );
                                    setState(() {});
                                  },
                                ),
                              ]
                              else ... [
                                  GestureDetector(
                                    child: Icon(
                                      Icons.star_border,
                                      size: global.total_height * 0.05,
                                    ),
                                    onTap: () {
                                      global.curr_user.saved.add(global.curr_article);
                                      global.globalFirestoreUpdate();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            duration: Duration(milliseconds: 800),
                                            content: Text(
                                                "Saved the article"
                                            )
                                        ),
                                      );
                                      setState(() {});
                                    },
                                  ),
                                ],
                            ],
                          ),
                          SizedBox(
                            width: global.total_width * 0.02,
                          )
                        ],
                      ),
                      SizedBox(
                        height: global.total_height * 0.01,
                      )
                    ],
                  )
                ],
              ),
            ),
            myBottomBar(),
          ],
        ),
      ),
    );
  }
}
