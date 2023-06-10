import 'package:flutter/material.dart';
import 'package:app/Pages/Variables.dart' as global;

class myBottomBar extends StatelessWidget {
  const myBottomBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                if(global.currPage != 0)
                {
                  global.currPage = 0;
                  Navigator.pushNamed(context, '/thread');
                }
              },
              child: Column(
                children: [
                  if(global.currPage == 0) ...[
                    Icon(Icons.square_outlined,
                      color: Colors.black,
                    ),
                  ]
                  else ...[
                    Icon(Icons.circle_outlined,
                      color: Colors.black,
                    ),
                  ],
                  Text('Article',
                    style: TextStyle(
                        color: Colors.black
                    ),
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                if(global.currPage != 1)
                {
                  global.currPage = 1;
                  Navigator.pushNamed(context, '/home');
                }
              },
              child: Column(
                children: [
                  if(global.currPage == 1) ...[
                    Icon(Icons.square_outlined,
                      color: Colors.black,
                    ),
                  ]
                  else ...[
                    Icon(Icons.circle_outlined,
                      color: Colors.black,
                    ),
                  ],
                  Text('Forum',
                    style: TextStyle(
                        color: Colors.black
                    ),
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                if(global.currPage != 2)
                {
                  global.currPage = 2;
                  Navigator.pushNamed(context, '/profile');
                }
              },
              child: Column(
                children: [
                  if(global.currPage == 2 || global.currPage == 3) ...[
                    Icon(Icons.square_outlined,
                      color: Colors.black,
                    ),
                  ]
                  else ...[
                    Icon(Icons.circle_outlined,
                      color: Colors.black,
                    ),
                  ],
                  Text('Profile',
                    style: TextStyle(
                        color: Colors.black
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}