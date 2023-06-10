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

class changePass extends StatefulWidget {
  const changePass({Key? key}) : super(key: key);

  @override
  State<changePass> createState() => _changePassState();
}

class _changePassState extends State<changePass> {

  final emailTextController = TextEditingController();
  final codeTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(global.total_width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: emailTextController,
                    decoration: InputDecoration(
                      hintText: 'Your email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  width: global.total_width * 0.05,
                ),
                GestureDetector(
                  child: Container(
                    width: global.total_width * 0.20,
                    height: global.total_height * 0.05,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                    child: Center(
                      child: Text('Send\nCode',
                        style: TextStyle(fontSize: global.total_width * 0.03),),
                    ),
                  ),
                  onTap: () {
                    FirebaseAuth.instance.sendPasswordResetEmail(email: emailTextController.text);
                  },
                )
              ],
            ),
            SizedBox(
              height: global.total_height * 0.03,
            ),
            TextField(
              controller: codeTextController,
              decoration: InputDecoration(
                hintText: 'Code sent to email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: global.total_height * 0.03,
            ),
            TextField(
              controller: passwordTextController,
              decoration: InputDecoration(
                hintText: 'New password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: global.total_height * 0.03,
            ),
            GestureDetector(
              child: Container(
                width: global.total_width * 0.20,
                height: global.total_height * 0.05,
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
                child: Center(
                  child: Text('Confirm',
                    style: TextStyle(fontSize: global.total_width * 0.03),),
                ),
              ),
              onTap: () {
                try {
                  FirebaseAuth.instance.confirmPasswordReset(
                      code: codeTextController.text,
                      newPassword: passwordTextController.text);
                }
                on Exception catch (e){
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          duration: Duration(milliseconds: 800),
                          content: Text(
                              e.toString()
                          )
                      )
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
