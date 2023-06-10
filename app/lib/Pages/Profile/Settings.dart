import 'package:app/Pages/myBottomBar.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/Pages/Variables.dart' as global;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../user.dart';
import 'package:app/Pages/Profile/Profile.dart';
import 'package:hive/hive.dart';

class settings extends StatefulWidget {
  const settings({Key? key}) : super(key: key);

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  late Box box;
  final nameTextController = TextEditingController();
  final descriptionTextController = TextEditingController();
  bool changePhoto = false;

  void createBox() async{
    box = await Hive.openBox('logindata');
  }

  @override
  void initState(){
    super.initState();
    createBox();
  }

  Future<void> photoChange(bool photolocation) async
  {
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
    ImagePicker imagePicker = ImagePicker();
    XFile? file;
    if(photolocation)
    {
       file = await imagePicker.pickImage(source: ImageSource.gallery);
    }
    else
    {
      file = await imagePicker.pickImage(source: ImageSource.camera);
    }


    if(file == null) return;

    var imagePath = await file!.readAsBytes();
    if (imagePath.length > 50 * 1048576)
    {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 800),
          content: Text(
            'File too big\nMax 50mb',
          ),
        ),
      );
      return;
    }

    String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDir = referenceRoot.child('images');

    if(!global.defaultimages.contains(global.curr_user.pr.imaget))
    {
      try{
        await FirebaseStorage.instance.refFromURL(global.curr_user.pr.imaget).delete();
      } catch (error) {
        print('couldnt delete from storage');
      }
    }

    Reference referenceImage = referenceDir.child(uniqueFileName);

    try{
      await referenceImage.putFile(File(file!.path));
      global.curr_user.pr.imaget = await referenceImage.getDownloadURL();
      global.globalFirestoreUpdate();
      for(int i = 0; i < global.curr_user.commented.length; i++)
      {
        global.curr_user.commented[i].imaget = global.curr_user.pr.imaget;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 800),
          content: Text(
            'Changed profile picture',
          ),
        ),
      );
      setState(() {});
    } catch (error) {
      print('didnt get downloadurl');
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    global.currPage = 3;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Settings',
                style: TextStyle(
                    fontSize: global.total_width * 0.09,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(
              height: global.total_width * 0.02312,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: global.total_height * 0.3,
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(child: Container(height: global.total_height * 0.03, child: Center(child: Text("Change PFP")))),
                        ),
                        onTap: () async {
                          changePhoto = !changePhoto;
                          setState(() {});
                        },
                      ),
                      if(changePhoto == true)...[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0, horizontal: global.total_width * 0.08),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
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
                                    child: Icon(
                                      Icons.camera_alt_outlined
                                    )
                                  )
                                ),
                                onTap: () async {
                                  await photoChange(false);
                                },
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
                                        child: Icon(
                                            Icons.camera
                                        )
                                    )
                                ),
                                onTap: () async{
                                  await photoChange(true);
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          child: TextField(
                            controller: nameTextController,
                            decoration: InputDecoration(
                              hintText: 'Change username',
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  if(nameTextController.text.length > 20)
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Duration(milliseconds: 800),
                                        content: Text(
                                          'Too long\nMax 20 chars',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  global.curr_user.pr.username = nameTextController.text;
                                  try{
                                    global.globalFirestoreUpdate();
                                    for(int i = 0; i < global.curr_user.commented.length; i++)
                                    {
                                      global.curr_user.commented[i].author_username = global.curr_user.pr.username;
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Duration(milliseconds: 800),
                                        content: Text(
                                          'Changed username',
                                        ),
                                      ),
                                    );
                                    setState(() {});
                                  } catch (error) {
                                    print('didnt get downloadurl');
                                  }
                                },
                                icon: const Icon(Icons.check))),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          child: TextField(
                            controller: descriptionTextController,
                            decoration: InputDecoration(
                              hintText: 'Change description',
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  if(descriptionTextController.text.length > 150)
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Duration(milliseconds: 800),
                                        content: Text(
                                          'Too long\nMax 150 chars',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  global.curr_user.pr.description = descriptionTextController.text;
                                  try{
                                    global.globalFirestoreUpdate();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Duration(milliseconds: 800),
                                        content: Text(
                                          'Changed description',
                                        ),
                                      ),
                                    );
                                    setState(() {});
                                  } catch (error) {
                                    print('didnt get downloadurl');
                                  }
                                },
                                icon: const Icon(Icons.check))),
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(child: Container(height: global.total_height * 0.03, child: Center(child: Text("Log Out")))),
                        ),
                        onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            await box.clear();
                            global.visiting_email = 'a';
                            global.curr_article = 'https://en.m.wikipedia.org/w/index.php?title=Special%3ASearch&search=';
                            global.curr_user = user(pr: profile(imaget: global.randomImage(), username: 'a', description: 'b', comment_post: 3,), email: "a", saved: [], admin: false, commented: [],);
                            Navigator.pushNamed(context, '/prelogin');
                        },
                      )
                    ]
                ),
              ),
            ),
            myBottomBar()
          ],
        ),
      ),
    );
  }
}
