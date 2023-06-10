import 'package:app/Pages/myBottomBar.dart';
import 'package:flutter/material.dart';
import 'package:app/Pages/Variables.dart' as global;

class profiles extends StatefulWidget {
  profiles({Key? key}) : super(key: key);
  @override
  State<profiles> createState() => _profilesState();
}

class _profilesState extends State<profiles> {


  @override
  void initState(){
    super.initState();
    //getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    global.currPage = 2;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: SingleChildScrollView(child: global.curr_user.pr), flex: 1,),
            myBottomBar()
          ],
        ),
      ),
    );
  }
}
