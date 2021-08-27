import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_project/models/auth_model.dart';
import 'package:task_project/widgets/widget.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/numbers_widget.dart';
import '../../widgets/profile_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    print(AuthModel().user.uid);
    return Scaffold(
        appBar: AppbarMain(title: Text("マイページ"), isAction: false),
        body: StreamBuilder<DocumentSnapshot>(
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
                  : ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        const SizedBox(height: 10),
                        ProfileWidget(
                          imagePath: snapshot.data['avatar_image_path'],
                          isMypage: true,
                        ),
                        const SizedBox(height: 22),
                        buildName(snapshot.data['name'], snapshot.data['id']),
                        const SizedBox(height: 24),
                        Center(child: buildUpgradeButton()),
                        const SizedBox(height: 24),
                        NumbersWidget(),
                        const SizedBox(height: 48),
                        buildAbout(snapshot.data['about']),
                      ],
                    );
            }));
  }

  Widget buildName(String name, String uid) => Column(
        children: [
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            "@" + uid,
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildUpgradeButton() => ButtonWidget(
        text: 'プロフィール編集',
        onClicked: () {
          Navigator.of(context).pushNamed("/edit-mypage");
        },
      );

  Widget buildAbout(String about) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              about,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );

  Future<int> showCupertinoBottomBar() {
    //選択するためのボトムシートを表示
    return showCupertinoModalPopup<int>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            message: Text('写真をアップロードしますか？'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  'カメラで撮影',
                ),
                onPressed: () {
                  Navigator.pop(context, 0);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  'アルバムから選択',
                ),
                onPressed: () {
                  Navigator.pop(context, 1);
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.pop(context, 2);
              },
              isDefaultAction: true,
            ),
          );
        });
  }

  void showBottomSheet() async {
    final result = await showCupertinoBottomBar();
    File file;
    final imagePicker = ImagePicker();

    if (result == 0) {
      final pickedFile = await imagePicker.getImage(source: ImageSource.camera);
      file = File(pickedFile.path);
    } else if (result == 1) {
      final pickedFile =
          await imagePicker.getImage(source: ImageSource.gallery);
      file = File(pickedFile.path);
    } else {
      return;
    }

    try {
      var task = await firebase_storage.FirebaseStorage.instance
          .ref('user_icon/' + AuthModel().user.uid + '.jpg')
          .putFile(file);

      task.ref.getDownloadURL().then((downloadURL) => FirebaseFirestore.instance
          .collection('user')
          .doc(AuthModel().user.uid)
          .update({'avatar_image_path': downloadURL}));
    } catch (e) {
      print("Image upload failed");
      print(e);
    }
  }
}
