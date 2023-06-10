import 'package:app/Pages/Comment/Comment-Base.dart';
import 'package:flutter/material.dart';
import 'package:app/Pages/Variables.dart' as global;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'ClickableComment.dart';

class deletableComment extends StatefulWidget {
  clickcomment comm;
  Function() delete;
  bool pressed = false;
  deletableComment({required this.comm, required this.delete});

  @override
  State<deletableComment> createState() => _deletableCommentState();
}

class _deletableCommentState extends State<deletableComment> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),

      ),
      child: Stack(
        children: [
          Center(
              child: widget.comm
          ),
          Row(
            children: [
              SizedBox(
                width: global.total_width * 0.80,
                height: global.total_height * 0.07,
              ),
              Column(
                children: [
                  SizedBox(
                    height: global.total_height * 0.01,
                  ),
                  GestureDetector(
                    key: Key("comment_button"),
                    onTap: () {
                      setState(() {
                        widget.pressed = !widget.pressed;
                      });
                    },
                    child: Icon(
                      Icons.more_vert,
                      size: global.total_width * 0.05,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: global.total_height * 0.01,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if(widget.comm.comm.likes[global.curr_user.email] == true)
                      {
                        widget.comm.comm.likes.remove(global.curr_user.email);
                      }
                      else
                      {
                        widget.comm.comm.ChangeMap(global.curr_user.email, true);
                      }
                      CollectionReference collection = await FirebaseFirestore.instance.collection('comments');
                      DocumentReference document = await collection.doc('comment' + widget.comm.comm.id.toString());
                      await document.update(widget.comm.comm.toFirestore());
                      setState(() {
                      });
                    },
                    child: Column(
                      children: [
                        if(widget.comm.comm.likes[global.curr_user.email] == true) ... [
                          Icon(
                            Icons.thumb_up,
                            size: global.total_width * 0.03,
                          ),
                        ]
                        else ...[
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            size: global.total_width * 0.03,
                          ),
                        ],
                        Text(getLikes(widget.comm.comm).toString()),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: global.total_height * 0.005,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if(widget.comm.comm.likes[global.curr_user.email] == false)
                      {
                        widget.comm.comm.likes.remove(global.curr_user.email);
                      }
                      else
                      {
                        widget.comm.comm.ChangeMap(global.curr_user.email, false);
                      }
                      CollectionReference collection = await FirebaseFirestore.instance.collection('comments');
                      DocumentReference document = await collection.doc('comment' + widget.comm.comm.id.toString());
                      await document.update(widget.comm.comm.toFirestore());
                      setState(() {
                      });
                    },
                    child: Column(
                      children: [
                        if(widget.comm.comm.likes[global.curr_user.email] == false) ... [
                          Icon(
                            Icons.thumb_down,
                            size: global.total_width * 0.03,
                          ),
                        ]
                        else ...[
                          Icon(
                            Icons.thumb_down_alt_outlined,
                            size: global.total_width * 0.03,
                          ),
                        ],
                        Text((widget.comm.comm.likes.length - getLikes(widget.comm.comm)).toString()),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: global.total_height * 0.01,
                  ),
                ],
              ),
            ],
          ),
          if (widget.pressed)
            Row(
              children: [
                SizedBox(
                  width: global.total_width * 0.700,
                  height: global.total_height * 0,
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        height: global.total_height * 0.01,
                      ),
                      if (global.curr_user.admin) ...[
                        Container(
                          child: GestureDetector(
                              key: Key("comment_delete"),
                              onTap: () {
                                widget.delete();
                              },
                              child: Text('Delete')),
                        ),
                      ],
                      Container(
                        child: GestureDetector(
                            onTap: () {
                              global.currPage = 0;
                              Navigator.pushNamed(context, '/thread');
                            },
                            child: Text('Go To')),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: global.total_width * 0.01,
                )
              ],
            )
        ],
      ),
      elevation: 2,
    );
  }
}
