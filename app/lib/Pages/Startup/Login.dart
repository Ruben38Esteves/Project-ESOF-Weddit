import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/Pages/Variables.dart' as global;
import '../user.dart';
import 'package:hive/hive.dart';



class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {

  final _textControllerEmail = TextEditingController();
  final _textControllerPwd = TextEditingController();

  late Box box;
  bool isChecked = false;

  void createBox() async{
    box = await Hive.openBox('logindata');
    getData();
  }

  void getData() async{
    if((box.get('email') != null) && (box.get('password') != null)){
      _textControllerEmail.text = box.get('email');
      _textControllerPwd.text = box.get('password');
      isChecked = true;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    createBox();
    getData();
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

  Future<String?> mailSignIn(String mail, String pwd) async {
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
          .signInWithEmailAndPassword(email: mail, password: pwd);
      FirebaseFirestore usr = FirebaseFirestore.instance;
      var documentSnapshot = await usr.collection("users").doc(FirebaseAuth.instance.currentUser?.email).get();
      if(documentSnapshot.exists)
      {
        global.curr_user = user.fromFirestore(documentSnapshot);
        await global.curr_user.getCommented();
      }
      Navigator.of(context).pop();
      return null;
    } on FirebaseAuthException catch (ex) {
      Navigator.of(context).pop();
      return "${ex.message}";
    }
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
                  'Log in',
                  style: TextStyle(
                    fontSize: global.total_width * 0.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: global.total_height * 0.38,
                ),
                TextField(
                  controller: _textControllerEmail,
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
                  height: global.total_height * 0.03,
                ),
                TextField(
                  controller: _textControllerPwd,
                  obscureText: true,
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
                  height: global.total_height * 0.03,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                            onPressed: () async {
                              String? error = await mailSignIn(_textControllerEmail.text.trim(), _textControllerPwd.text.trim());
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
                                FirebaseFirestore.instance.enableNetwork();
                                rememberUser();
                                global.currPage = 0;
                                Navigator.pushNamed(context, '/thread');
                              }
                            },
                            color: Colors.black,
                            child: const Text(
                              'Log in',
                              style: TextStyle(color: Colors.white),
                            )
                        ),
                        rememberMeBox()
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: global.total_height * 0.03,
                ),
                GestureDetector(
                  child: Text('Forgot Password',
                  style: TextStyle(
                    fontSize: global.total_height * 0.02
                  ),),
                  onTap: () {
                    FirebaseAuth.instance.sendPasswordResetEmail(email: _textControllerEmail.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            duration: Duration(milliseconds: 800),
                            content: Text(
                                "An email was sent to reset your password"
                            )
                        )
                    );
                    },
                )
              ],
            ),
          ),
        ),
      ),
    );

  }
}
