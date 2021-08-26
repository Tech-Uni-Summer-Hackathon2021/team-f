import 'package:flutter/material.dart';
import '../opening_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Text('タスクリスト'),
    actions: <Widget>[
      Padding(
        padding: EdgeInsets.only(right: 10.0),
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            _auth.currentUser != null ?
              CircleAvatar(
              radius: 20,
              child: ClipOval(
                child: Image.asset(
                  'assets/logo.png',
                ),
              ),
            )
            : CircleAvatar(
              radius: 20,
              child: ClipOval(
                child: Image.asset(
                  'assets/default.jpeg',
                ),
              ),
            ),
            Positioned(
              right: 0.0,
              width: 40.0,
              height: 40.0,
              child: RawMaterialButton(
                onPressed: () {
                  print("aaa");
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => MyPageScreen(title: 'マイページ')));
                },
                shape: CircleBorder(),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget drawerMain(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(),
        ListTile(
            leading: Icon(Icons.logout),
            title: Text('ログアウト'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text('ログアウトしてもよろしいですか？'),
                      actions: [
                        FlatButton(
                          child: Text('ログアウト'),
                          onPressed: () async {
                            await _auth.signOut();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OpeningView()),
                                (_) => false);
                          },
                        ),
                        FlatButton(
                          child: Text('キャンセル'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            }),
        ListTile(
            leading: Icon(Icons.mail),
            title: Text('メール'),
            onTap: () {
              print("メール");
            })
      ],
    ),
  );
}
