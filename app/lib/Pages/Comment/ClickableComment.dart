import 'package:app/Pages/Comment/Comment-Base.dart';
import 'package:flutter/material.dart';

class clickcomment extends StatelessWidget {
  final comment comm;
  final String location;

  const clickcomment({required this.comm, required this.location});

  @override
  Widget build(BuildContext context) {
    if(location == '')
      {
        return comm;
      }
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, location);
      },
      child: comm
    );
  }
}
