import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_project/models/auth_model.dart';
//import 'package:task_project/screens/Home/list_add_SNS.dart';
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
                    stream: FirebaseFirestore.instance
                        .collection('user')
                        .doc(AuthModel().user.uid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      return (!snapshot.hasData)
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [CircularProgressIndicator()],
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: Stack(
                                alignment: Alignment.centerRight,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(snapshot
                                        .data['avatar_image_path']
                                        .toString()),
                                  ),
                                  Positioned(
                                    right: 0.0,
                                    width: 40.0,
                                    height: 40.0,
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed("/mypage");
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
            leading: Icon(Icons.api),
            title: Text('??????????????????????????????'),
            onTap: () {
              //return TodoSNSPage();
              print("????????????");
            }),
        ListTile(
            leading: Icon(Icons.logout),
            title: Text('???????????????'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text('????????????????????????????????????????????????'),
                      actions: [
                        FlatButton(
                          child: Text('???????????????'),
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
                          child: Text('???????????????'),
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
