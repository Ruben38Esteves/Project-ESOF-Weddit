import 'package:app/Pages/Profile/Profile.dart';
import 'user.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

String curr_article = 'https://en.m.wikipedia.org/w/index.php?title=Special%3ASearch&search=';

user curr_user = user(pr: profile(imaget: randomImage(), username: 'a', description: 'b', comment_post: 3,), email: "a", saved: [], admin: false, commented: [],);

double total_width = 0;
double total_height = 0;
int currPage = 0;

List<String> defaultimages = [
  'https://firebasestorage.googleapis.com/v0/b/weddit-d0e3b.appspot.com/o/images%2Fcp1.png?alt=media&token=1b99e748-e189-4855-9da3-ee81834d2e3b',
  'https://firebasestorage.googleapis.com/v0/b/weddit-d0e3b.appspot.com/o/images%2Fcp10.jpg?alt=media&token=e2c303d8-bf8d-4c81-bbf5-586b98dd7497',
  'https://firebasestorage.googleapis.com/v0/b/weddit-d0e3b.appspot.com/o/images%2Fcp2.jpg?alt=media&token=37697058-8fc4-47e0-85f1-723dc945e73d',
  'https://firebasestorage.googleapis.com/v0/b/weddit-d0e3b.appspot.com/o/images%2Fcp3.jpg?alt=media&token=8b0830eb-7c07-422f-b134-72b733b67c87',
  'https://firebasestorage.googleapis.com/v0/b/weddit-d0e3b.appspot.com/o/images%2Fcp4.jpg?alt=media&token=46f3351c-0092-4488-b9d9-2172dc3db834',
  'https://firebasestorage.googleapis.com/v0/b/weddit-d0e3b.appspot.com/o/images%2Fcp5.png?alt=media&token=168c965e-b2de-466b-942b-beeb83d7009f',
  'https://firebasestorage.googleapis.com/v0/b/weddit-d0e3b.appspot.com/o/images%2Fcp6.png?alt=media&token=5edf542e-0c2f-49b7-afce-b9cdd1f3914d',
  'https://firebasestorage.googleapis.com/v0/b/weddit-d0e3b.appspot.com/o/images%2Fcp7.png?alt=media&token=1668307a-e71a-462f-a24f-d649ef610409',
  'https://firebasestorage.googleapis.com/v0/b/weddit-d0e3b.appspot.com/o/images%2Fcp8.jpg?alt=media&token=000fecba-67e9-4449-95ac-0c03b41258eb',
  'https://firebasestorage.googleapis.com/v0/b/weddit-d0e3b.appspot.com/o/images%2Fcp9.jpg?alt=media&token=c20e574b-935d-41c4-9335-af2e2d822679'
];

String randomImage()
{
  final _random = new Random();
  return defaultimages[_random.nextInt(defaultimages.length)];
}

String visiting_email = 'a';

Map<String, dynamic> FirestoreUpdate() {
  return {
    "imaget": curr_user.pr.imaget,
    "username": curr_user.pr.username,
    "description": curr_user.pr.description,
    "comment_post": curr_user.pr.comment_post,
    "admin": curr_user.admin,
    "email": curr_user.email,
    "saved": curr_user.saved
  };
}

void globalFirestoreUpdate() async {
  CollectionReference collection = await FirebaseFirestore.instance.collection('users');
  DocumentReference document = await collection.doc(curr_user.email);
  await document.update(FirestoreUpdate());
}

dynamic reloadWebView = 1;