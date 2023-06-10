import 'package:app/Pages/Comment/ClickableComment.dart';
import 'package:app/Pages/Comment/Comment-Base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'myBottomBar.dart';
import 'Comment/Deletable-Comment.dart';
import 'package:app/Pages/Variables.dart' as global;
import 'package:app/Pages/Profile/Profile.dart';
import 'user.dart';

List<comment> comments = [];


class home extends StatefulWidget {

  home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  late Future<void> futureData;
  final commentTextController = TextEditingController();

  profile x = profile(imaget: global.randomImage(), username: 'unknown', description: 'description', comment_post: 0,);
  FirebaseFirestore usr = FirebaseFirestore.instance;
  Future<void> getUserFromEmail (String email) async{
    var docced = await usr.collection("users").doc(email);
    var documentSnapshot = await docced.get();
    {
      if(documentSnapshot.exists)
      {
        x = user.fromFirestore(documentSnapshot).pr;
      }
      else
      {
        x = profile(imaget: global.randomImage(), username: 'unknown', description: 'description', comment_post: 0,);
      }
    };
  }

  void SortComments () {
    bool troca;
    for(int j = comments.length - 1; j > 0; j--)
    {
      troca = false;
      for(int i = 0; i < j; i++)
      {
        if(comments[i + 1] < comments[i])
        {
          comment tmp = comments[i + 1];
          comments[i + 1] = comments[i];
          comments[i] = tmp;
          troca = true;
        }
      }
      if(!troca) return;
    }
  }

  Future<void> fillComments() async {

    FirebaseFirestore db = FirebaseFirestore.instance;

    final ref = await db.collection("comments").withConverter(
        fromFirestore: comment.fromFirestore,
        toFirestore: (comment cmt, _) => cmt.toFirestore()
    );

    var queryComments = await ref.where("article", isEqualTo: global.curr_article).get();
    for (var cmt in queryComments.docs) {
      comments.add(cmt.data());
    }
    for (int i = 0; i < comments.length; i++)
    {
      try{
        await getUserFromEmail(comments[i].author).then((value) {
          comments[i].imaget = x.imaget;
          comments[i].author_username = x.username;
          });
      } catch (error)
      {
        comments[i].imaget = global.randomImage();
        comments[i].author_username = "unknown";
      }
    }
    SortComments();
  }
  @override
  void initState(){
    super.initState();

    comments.clear();

    futureData = fillComments();
  }



  Future<void> addComment(String content) async{
    Map<String, dynamic> likes = Map();
    final ref = db.collection("comments");
    int newN = 0;
    await ref.get().then(
            (queryComments) {
          for (var cmt in queryComments.docs){
            if(cmt.data()['id'] > newN)
            {
              newN = cmt.data()['id'];
            }
          }
          newN++;
        }
    );
    final newComment = <String,dynamic>{
      "article":global.curr_article,
      "author":global.curr_user.email,
      "content":content,
      "id":newN,
      "likes": likes
    };
    await db.collection("comments").doc("comment"+newN.toString()).set(newComment);
    var documentSnapshot = await db.collection("comments").doc("comment"+newN.toString()).get();
    comments.add(comment.fromFirestore2(documentSnapshot));
    comments[comments.length - 1].author_username = global.curr_user.pr.username;
    comments[comments.length - 1].imaget = global.curr_user.pr.imaget;
    //newC = ref.count();
    global.curr_user.pr.comment_post++;
    global.globalFirestoreUpdate();
    setState(() {});

  }

  void deleteUserCommented(String email) async {
    var documentSnapshot = await usr.collection("users").doc(email).get();
    user prpr;
    if(documentSnapshot.exists)
    {
      prpr = await user.fromFirestore(documentSnapshot);
      await global.curr_user.getCommented();
      prpr.pr.comment_post--;
      if(email == global.curr_user.email)
      {
        global.curr_user.pr.comment_post--;
      }
      await prpr.FirestoreUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    global.currPage = 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: global.total_height * 0.01,),
            Container(
              child: Builder(
                builder: (context) {
                  if(global.curr_article.contains('Search&search=') || global.curr_article.contains('Special%3ASearch')){
                    return Text(
                      'Search',
                      style: TextStyle(
                          fontSize: global.total_width * 0.1
                      ),
                    );
                  }
                  else
                  {
                    return Text(
                      global.curr_article.substring(32).replaceAll('_', ' '),
                      style: TextStyle(
                          fontSize: global.total_width * 0.1,
                          fontWeight: FontWeight.bold
                      ),
                    );
                  }

                },
              )
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: FutureBuilder<void>(
                    future: futureData,
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.done)
                      {
                        return Column(
                            children: comments.map((comment1) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  child: deletableComment(comm: clickcomment(comm: comment1, location: ''), delete: () {

                                    setState(() {
                                      comments.remove(comment1);

                                      db.collection("comments").doc('comment' + comment1.id.toString()).delete().then(
                                            (doc) => print("Document deleted"),
                                        onError: (e) => print("Error updating document $e"),
                                      );
                                      deleteUserCommented(comment1.author);
                                    });
                                  })
                              );
                            }).toList()
                        );
                      }
                      else
                      {
                        return CircularProgressIndicator(
                          color: Colors.grey[700],
                          backgroundColor: Colors.grey.shade100,
                        );
                      }
                    }
                  )
                ),
              ),
            ),
            Container(
              child: TextField(
                controller: commentTextController,
                decoration: InputDecoration(
                    hintText: 'Leave a comment here!',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                        onPressed: () {
                          print("1");
                          if(!(global.curr_article.contains('Search&search=') || global.curr_article.contains('Special%3ASearch'))) {
                            commentTextController.text = commentTextController.text.trim();
                            print("2");
                            if(commentTextController.text == "")
                            {
                              print("3");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    duration: Duration(seconds: 1),
                                    content: Text(
                                        "Comment needs to have content"
                                    )
                                ),
                              );
                              return;
                            }
                            if(commentTextController.text.length > 512)
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    duration: Duration(seconds: 1),
                                    content: Text(
                                        "Too long\nMax 512 chars"
                                    )
                                ),
                              );
                              return;
                            }
                            addComment(commentTextController.text);
                            commentTextController.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  duration: Duration(milliseconds: 800),
                                  content: Text(
                                      "Comment has been posted successfully"
                                  )
                              ),
                            );
                            setState(() {

                            });
                          }
                          print("4");
                        },
                        icon: const Icon(Icons.send))),
              ),
            ),
            myBottomBar()
          ],
        ),
      ),
    );
  }
}


