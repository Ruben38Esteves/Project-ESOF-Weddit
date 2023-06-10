import 'package:app/Pages/Comment/Comment-Base.dart';
import 'package:app/Pages/Profile/Profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class user extends StatelessWidget {
  profile pr;
  List<dynamic> saved;
  List<comment> commented;
  final String email;
  final bool admin;
  user({required this.pr, required this.email, required this.saved, required this.admin, required this.commented});

  void SortComments () {
    bool troca;
    for(int j = commented.length - 1; j > 0; j--)
    {
      troca = false;
      for(int i = 0; i < j; i++)
      {
        if(commented[i + 1] < commented[i])
        {
          comment tmp = commented[i + 1];
          commented[i + 1] = commented[i];
          commented[i] = tmp;
          troca = true;
        }
      }
      if(!troca) return;
    }
  }

  Future<int> getCommented () async{
    List<comment> comments = [];
    FirebaseFirestore db = FirebaseFirestore.instance;

    final ref = await db.collection("comments").withConverter(
        fromFirestore: comment.fromFirestore,
        toFirestore: (comment cmt, _) => cmt.toFirestore()
    );

    var queryComments = await ref.where("author", isEqualTo: email).get();
    for (var cmt in queryComments.docs) {
      comments.add(cmt.data());
    }
    commented = comments;
    SortComments();
    for(int i = 0; i < commented.length; i++)
    {
      commented[i].author_username = this.pr.username;
      commented[i].imaget = this.pr.imaget;
    }
    return 0;
  }

  factory user.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,) {


    final data = snapshot.data();
    return user(
      pr: profile(
        imaget: data?['imaget'],
        username: data?['username'],
        description: data?['description'],
        comment_post: data?['comment_post'],
      ),
      commented: [],
      admin: data?['admin'],
      email: data?['email'],
      saved: data?['saved'],
    );
  }

  Map<String, dynamic> FirestoreUpdate2() {
    return {
      "imaget": this.pr.imaget,
      "username": this.pr.username,
      "description": this.pr.description,
      "comment_post": this.pr.comment_post,
      "admin": this.admin,
      "email": this.email,
      "saved": this.saved
    };
  }

  Future<int> FirestoreUpdate() async {
    CollectionReference collection = await FirebaseFirestore.instance.collection('users');
    DocumentReference document = await collection.doc(this.email);
    await document.update(FirestoreUpdate2());
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
