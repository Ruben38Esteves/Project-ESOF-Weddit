import 'package:flutter/material.dart';
import 'package:app/Pages/Variables.dart' as global;

class profile extends StatefulWidget {

  String imaget;

  String username;

  String description;

  int comment_post;

  profile({required this.imaget, required this.username, required this.description, required this.comment_post});


  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    global.currPage = 2;
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                  child: CircleAvatar(
                    radius: 103,
                    backgroundColor: Colors.grey[600],
                    child: CircleAvatar(
                      backgroundImage: Image.network(widget.imaget).image,
                      backgroundColor: Colors.white,
                      radius: 100,
                    ),
                  ),
                ),
                VerticalDivider(
                  thickness: 2,
                  color: Colors.black,
                  width: global.total_width * 0.12,
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                      child: Row(
                        children: [
                          Icon(Icons.settings),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Settings',
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/saved');
                      },
                      child: Row(
                        children: [
                          Icon(Icons.folder),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Saved\nPosts',
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )

              ],
            ),
            Text(
              widget.username!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: global.total_width * 0.07,
                fontFamily: 'Arial'
              ),
            ),
            SizedBox(
              height: global.total_height * 0.015,
            ),
            Text(
              widget.description!,
            ),
            Divider(
              color: Colors.black,
              thickness: 2,
              height: global.total_height * 0.06,
            ),
            Text(
              'Comments posted:          ${widget.comment_post}'
            ),
            Divider(
              color: Colors.black,
              thickness: 2,
              height: global.total_height * 0.06,
            ),
            Column(
              children: [
                if(global.curr_user.commented.length > 4) ...global.curr_user.commented.sublist(0, 4).map((_comment) {
                  return Column(
                    children: [
                      GestureDetector(
                        child: Card(
                          elevation: 2,
                          child: _comment,
                        ),
                        onTap: () {
                          global.curr_article = _comment.url;
                          global.currPage = 1;
                          Navigator.pushNamed(context, "/home");
                        },
                      ),
                      SizedBox(
                        height: global.total_height * 0.015,
                      ),
                    ],
                  );
                }).toList()
                else ...global.curr_user.commented.map((_comment) {
                  return Column(
                    children: [
                      GestureDetector(
                        child: Card(
                          elevation: 2,
                          child: _comment,
                        ),
                        onTap: () {
                          global.curr_article = _comment.url;
                          global.currPage = 1;
                          Navigator.pushNamed(context, "/home");
                        },
                      ),
                      SizedBox(
                      height: global.total_height * 0.015,
                      ),
                    ],
                  );
                }).toList(),
              ]
            ),
          ],
        ),
      ),
    );
  }
}
