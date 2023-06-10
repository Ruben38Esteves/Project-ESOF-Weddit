import 'package:app/Pages/myBottomBar.dart';
import 'package:flutter/material.dart';
import 'package:app/Pages/Variables.dart' as global;

class saved extends StatefulWidget {
  const saved({Key? key}) : super(key: key);

  @override
  State<saved> createState() => _savedState();
}

class _savedState extends State<saved> {
  @override
  Widget build(BuildContext context) {
    global.currPage = 3;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Saved Posts',
                      style: TextStyle(
                          fontSize: global.total_width * 0.09,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  SizedBox(
                    height: global.total_width * 0.02312,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(global.curr_user.saved.length > 0) ...
                        global.curr_user.saved.map((article) {
                          return GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Card(
                                child: Container(
                                  height: global.total_height * 0.05,
                                  child: Center(
                                    child: Text(
                                      article.substring(32).replaceAll('_', ' '),
                                      style: TextStyle(
                                          fontSize: global.total_width * 0.05
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              global.curr_article = article;
                              global.currPage = 0;
                              Navigator.pushNamed(context, '/thread');
                            },
                          );
                        }).toList()
                        else ... [
                          SizedBox(
                            height: global.total_height * 0.43,
                          ),
                          Text(
                            'No Saved Posts',
                            style: TextStyle(
                                fontSize: global.total_width * 0.05
                            ),
                          ),
                        ]
                      ]
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Expanded(child: Container()),
                myBottomBar()
              ],
            )
          ],
        ),
      ),
    );
  }
}
