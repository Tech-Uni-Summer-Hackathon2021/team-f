import 'package:flutter/material.dart';
import '../opening_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
      );
}

final FirebaseAuth _auth = FirebaseAuth.instance;
Widget drawerMain(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
),
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
            })
      ],
    ),
  );
}
