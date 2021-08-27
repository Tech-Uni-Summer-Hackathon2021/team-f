import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_project/models/auth_model.dart';
import '../opening_screen.dart';

class AppbarMain extends StatelessWidget with PreferredSizeWidget {
  final Widget title;
  final bool isAction;

  AppbarMain({
    this.title,
    this.isAction,
  });
  

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: title,
        actions: isAction
            ? <Widget>[
              StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore
                .instance.collection("user")
                .doc(AuthModel().user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              return 
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 20,
                        child: ClipOval(child: Image.network(snapshot.data.get('avatar_image_path').toString(),)),
                      ),
                      Positioned(
                        right: 0.0,
                        width: 40.0,
                        height: 40.0,
                        child: RawMaterialButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed("/mypage");
                            print("aaa");
                          },
                          shape: CircleBorder(),
                        ),
                      ),
                    ],
                  ),
                );
            })
              ]
            : null);
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
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
                          onPressed: () {
                            AuthModel().logout().then((value) =>
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OpeningView()),
                                    (_) => false));
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
