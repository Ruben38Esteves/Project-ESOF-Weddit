import 'package:flutter/material.dart';
import 'package:app/Pages/Variables.dart' as global;
import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../user.dart';

class prelogin extends StatefulWidget {
  const prelogin({Key? key}) : super(key: key);

  @override
  State<prelogin> createState() => _preloginState();
}

class _preloginState extends State<prelogin> {

  late Box box;

  void getData() async{
    if((box.get('email') != null) && (box.get('password') != null)){
      showDialog(
          context: context,
          builder: (context){
            return Center(
              child: CircularProgressIndicator(
                color: Colors.grey[700],
                backgroundColor: Colors.grey.shade100,
              ),
            );
          }
      );
      try {
        if(Firebase.apps.isEmpty) {
          await Firebase.initializeApp();
        }
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: box.get('email'), password: box.get('password'));
        FirebaseFirestore usr = FirebaseFirestore.instance;
        var documentSnapshot = await usr.collection("users").doc(FirebaseAuth.instance.currentUser?.email).get();
        if(documentSnapshot.exists)
        {
          global.curr_user = user.fromFirestore(documentSnapshot);
          await global.curr_user.getCommented();
        }
        Navigator.of(context).pop();
      } on FirebaseAuthException catch (ex) {
        Navigator.of(context).pop();
      }
      global.currPage = 0;
      Navigator.pushNamed(context, '/thread');
    }
  }

  void createBox() async{
    box = await Hive.openBox('logindata');
    getData();
  }

  @override
  void initState() {
    createBox();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    global.total_width = MediaQuery.of(context).size.width;
    global.total_height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                  'assets/logo.png',
                width: global.total_width * 0.3,
              ),
              Text(
                'eddit',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: global.total_width * 0.1,
                  fontFamily: 'Arial'
                ),
              )
            ],
          ),
          SizedBox(
            height: global.total_height * 0.01,
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            child: Text(
              'Log in',
              style: TextStyle(
                fontSize: global.total_width * 0.05,
                color: Colors.black,
                fontFamily: 'Arial'
              ),
            ),
          ),
          SizedBox(
            height: global.total_height * 0.01,
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            child: Text(
              'Register',
              style: TextStyle(
                fontSize: global.total_width * 0.05,
                color: Colors.black,
                fontFamily: 'Arial'
              ),
            ),
          ),
        ],
      ),
    );
  }
}
