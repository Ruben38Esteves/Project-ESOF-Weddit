import 'package:app/Pages/Profile/Profile.dart';
import 'package:flutter/material.dart';
import 'package:app/Pages/Variables.dart' as global;

class otherProfile extends StatefulWidget {

  final profile pr;

  final List<dynamic> commented;

  const otherProfile({required this.pr, required this.commented});


  @override
  State<otherProfile> createState() => _otherProfileState();
}

class _otherProfileState extends State<otherProfile> {

  @override
  Widget build(BuildContext context) {
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
                      backgroundImage: Image.network(widget.pr.imaget).image,
                      backgroundColor: Colors.white,
                      radius: 100,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              widget.pr.username!,
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
              widget.pr.description!,
            ),
            Divider(
              color: Colors.black,
              thickness: 2,
              height: global.total_height * 0.06,
            ),
            /*Text(
              'Article contributed to:     $art_contributed'
            ),
            SizedBox(
              height: 20,
            ),*/
            Text(
                'Comments posted:          ${widget.pr.comment_post}'
            ),
            Divider(
              color: Colors.black,
              thickness: 2,
              height: global.total_height * 0.06,
            ),
            Column(
              children: [
                if(widget.commented.length > 4) ...widget.commented.sublist(0, 4).map((_comment) {
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
                else ...widget.commented.map((_comment) {
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
