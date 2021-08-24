import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class AuthScreen extends StatefulWidget {


  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // アカウント登録
  void registeUser() async {
    await FirebaseAuth.instance.signInAnonymously().then((result) => {
      print("User id is ${result.user.uid}"),
      //ページ遷移
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyTodoApp()),
          (_) => false)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('team-f | test'),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 40.0),
              Container(
                height: 300,
              ),
              RaisedButton(
                padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                onPressed: () {
                  registeUser();
                },
                child: Text('匿名ログイン',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
                color: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              )
            ],
          ),
        ));
  }
}
