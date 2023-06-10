import 'package:app/Pages/myBottomBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/Pages/Variables.dart' as global;
import 'package:app/Pages/Profile/OtherProfile.dart';
import 'package:app/Pages/user.dart';

class otherProfileDisplay extends StatefulWidget {

  const otherProfileDisplay();

  @override
  State<otherProfileDisplay> createState() => _otherProfileDisplayState();
}

class _otherProfileDisplayState extends State<otherProfileDisplay> {

  late Future<void> futureData;
  late user _user;

  @override
  void initState(){
    super.initState();
    futureData = getInfo();
  }

  Future<void> getInfo () async {
    FirebaseFirestore usr = await FirebaseFirestore.instance;
    var documentSnapshot = await usr.collection("users").doc(global.visiting_email).get();
    if(documentSnapshot.exists)
    {
      _user = user.fromFirestore(documentSnapshot);
      await _user.getCommented();
    }
  }

  @override
  Widget build(BuildContext context) {
    getInfo();
    global.currPage = 3;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: SingleChildScrollView(child: FutureBuilder<void>(
              future: futureData,
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done)
                {
                  return otherProfile(pr: _user.pr, commented: _user.commented,);
                }
                else
                {
                  return CircularProgressIndicator(
                    color: Colors.grey[700],
                    backgroundColor: Colors.grey.shade100,
                  );
                }
              }
            )), flex: 1,),
            myBottomBar()
          ],
        ),
      ),
    );
  }
}
