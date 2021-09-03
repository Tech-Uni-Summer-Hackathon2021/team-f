import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_project/routes/route.dart';
import 'package:provider/provider.dart';
import 'package:task_project/screens/Home/home.dart';
import 'models/auth_model.dart';
import 'opening_screen.dart';

//import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Firebase初期化処理
  await Firebase.initializeApp();
  // 最初に表示するWidget
  runApp(MyTodoApp());
  //firebaseAddData();
}

class MyTodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AuthModel(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'My Todo App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          routes: AppRoutes.define(),
          home: _LoginCheck(),
        ));
  }
}

/*class Memo {
  final int id;
  final String text;

  Memo({this.id, this.text});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
    };
  }
}*/

class _LoginCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ログイン状態に応じて、画面を切り替える
    //AuthModelで一括管理
    final bool _loggedIn = context.watch<AuthModel>().loggedIn;
    return _loggedIn ? TodoListPage() : OpeningView();
  }
}
