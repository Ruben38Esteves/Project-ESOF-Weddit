import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/Pages/Variables.dart' as global;

int getLikes(comment com)
{
  int x = 0;
  for(var i in com.likes.values)
    {
      if(i == true)
        {
          x++;
        }
    }
  return x;
}

class comment extends StatefulWidget {
  String imaget;
  String author_username;
  String url;
  final String author;
  final String text;
  final int id;
  final Map<String, dynamic> likes;


  comment({required this.imaget, required this.author, required this.text, required this.id, required this.likes, required this.author_username, required this.url});

  void ChangeMap(String key, dynamic value) {
    likes[key] = value;
  }

  @override
  bool operator <(comment a){
    if(getLikes(this) == getLikes(a)) return (this.likes.length - getLikes(this)) < (a.likes.length - getLikes(a));
    return getLikes(this) > getLikes(a);
  }

  factory comment.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return comment( //data?['author']
      imaget: global.randomImage(),
      author: data?['author'],
      text: data?['content'],
      id: data?['id'],
      likes: data?['likes'],
      author_username: data?['author'],
      url: data?['article'],
    );
  }

  factory comment.fromFirestore2(DocumentSnapshot<Map<String, dynamic>> snapshot,) {
    final data = snapshot.data();
    return comment( //data?['author']
      imaget: global.randomImage(),
      author: data?['author'],
      text: data?['content'],
      id: data?['id'],
      likes: data?['likes'],
      author_username: data?['author'],
      url: data?['article'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (author != null) "author": author,
      if (text != null) "content": text,
      if (id != null) "id": id,
      if (global.curr_article != null) "article": global.curr_article,
      "likes": likes
    };
  }

  @override
  State<comment> createState() => _commentState();
}



class _commentState extends State<comment> {

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if(widget.author == global.curr_user.email)
              {
                global.currPage = 2;
                Navigator.pushNamed(context, '/profile');
              }
              else
              {
                global.visiting_email = widget.author;
                global.currPage = 2;
                Navigator.pushNamed(context, '/otherprofile');
              }
            },
            child: CircleAvatar(
              radius: 26,
              backgroundColor: Colors.grey[600],
              child: CircleAvatar(
                backgroundImage: Image.network(
                  widget.imaget,
                ).image,
                backgroundColor: Colors.white,
                radius: 25,
              ),
            ),
          ),
          SizedBox(width: global.total_width * 0.02,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  if(widget.author == global.curr_user.email)
                  {
                    global.currPage = 2;
                    Navigator.pushNamed(context, '/profile');
                  }
                  else
                  {
                    global.currPage = 2;
                    global.visiting_email = widget.author;
                    Navigator.pushNamed(context, '/otherprofile');
                  }
                },
                child: Text(
                  widget.author_username,
                ),
              ),
              SizedBox(
                width: global.total_width * 0.65,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
                  child: Text(
                    widget.text,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      color: Colors.white,
    );
  }
}
