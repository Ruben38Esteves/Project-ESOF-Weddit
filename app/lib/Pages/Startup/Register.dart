import 'package:app/Pages/Profile/Profile.dart';
import 'package:csv/csv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/Pages/Variables.dart' as global;
import '../user.dart';
import 'package:hive/hive.dart';

Future<void> addUser(user usr) async{
  FirebaseFirestore db = FirebaseFirestore.instance;
  final ref = db.collection("users");
  final newPr = <String,dynamic>{
    "username":usr.pr.username,
    "email":usr.email,
    "description":usr.pr.description,
    "comment_post":0,
    "admin": false,
    "imaget":usr.pr.imaget,
    "saved": usr.saved
  };
  db.collection("users").doc(usr.email).set(newPr);
}

Future<String?> mailRegister(String mail, String pwd) async {
  try {
    if(Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: mail, password: pwd);
    return null;
  } on FirebaseAuthException catch (ex) {
    return "${ex.message}";
  }
}

Future<String?> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    return null;
  } on FirebaseAuthException catch (ex) {
    return "${ex.message}";
  }
}

class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  final _textControllerEmail = TextEditingController();
  final _textControllerUsername = TextEditingController();
  final _textControllerPwd = TextEditingController();

  List<List<dynamic>> _accounts = [];

  void _loadCSV() async {
    final _rawData = await rootBundle.loadString("data/accounts.csv");
    List<List<dynamic>> _listData =
        const CsvToListConverter().convert(_rawData);
    setState(() {
      _accounts = _listData;
    });
  }

  late Box box;
  bool isChecked = false;

  void createBox() async{
    box = await Hive.openBox('logindata');
  }

  @override
  void initState() {
    super.initState();
    createBox();
  }

  void rememberUser(){
    if(isChecked){
      box.put('email', _textControllerEmail.text);
      box.put('password', _textControllerPwd.text);
    }
    else{
      box.clear();
    }
  }

  Widget rememberMeBox() {
    return Row(
      children: [
        Checkbox(
            value: isChecked,
            onChanged: (value) {
              setState(() {
                isChecked = value!;
              });
            }
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Remember',
              style: TextStyle(
                  fontSize: global.total_width * 0.025
              ),),
            Text('me',
              style: TextStyle(
                  fontSize: global.total_width * 0.025
              ),),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Register',
                  style: TextStyle(
                    fontSize: global.total_width * 0.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: global.total_height * 0.3,
                ),
                TextField(
                  controller: _textControllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                          onPressed: () {
                            _textControllerEmail.clear();
                          },
                          icon: const Icon(Icons.clear))),
                ),
                SizedBox(
                  height: global.total_height * 0.02,
                ),
                TextField(
                  controller: _textControllerUsername,
                  decoration: InputDecoration(
                      hintText: 'Username',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                          onPressed: () {
                            _textControllerUsername.clear();
                          },
                          icon: const Icon(Icons.clear))),
                ),
                SizedBox(
                  height: global.total_height * 0.02,
                ),
                TextField(
                  controller: _textControllerPwd,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                          onPressed: () {
                            _textControllerPwd.clear();
                          },
                          icon: const Icon(Icons.clear))),
                ),
                SizedBox(
                  height: global.total_height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                        onPressed: () async {
                          String? error = await mailRegister(_textControllerEmail.text.trim(), _textControllerPwd.text.trim());
                          if(error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  duration: Duration(milliseconds: 800),
                                  content: Text(
                                      error
                                  )
                              ),
                            );
                          } else {
                            await FirebaseFirestore.instance.enableNetwork();
                            global.curr_user = user(pr: profile(imaget: global.randomImage(), username: _textControllerUsername.text, description: "no description", comment_post: 0,), admin: false, saved: [], email: FirebaseAuth.instance.currentUser!.email!, commented: [],);
                            addUser(global.curr_user);
                            rememberUser();
                            global.currPage = 0;
                            Navigator.pushNamed(context, '/thread');
                          }
                        },
                        color: Colors.black,
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        )
                    ),
                    rememberMeBox(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
