import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_project/models/auth_model.dart';
import 'package:task_project/widgets/button_widget.dart';
import 'package:task_project/widgets/widget.dart';
import '../../widgets/profile_widget.dart';
import '../../widgets/textfield_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String name, id, about;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppbarMain(title: Text("プロフィール編集"), isAction: false),
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
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      physics: BouncingScrollPhysics(),
                      children: [
                        ProfileWidget(
                          imagePath: snapshot.data['avatar_image_path'],
                          isEdit: true,
                          isMypage: false,
                          onClicked: () {
                            showBottomSheet();
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFieldWidget(
                          label: 'Full Name',
                          text: snapshot.data['name'],
                          onChange: (input) {
                            setState(() {
                              name = input;
                            }); 
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFieldWidget(
                          label: 'ID',
                          text: snapshot.data['id'],
                          onChange: (input) {
                            setState(() {
                              id = input;
                            }); 
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFieldWidget(
                          label: 'About',
                          text: snapshot.data['about'],
                          maxLines: 5,
                          onChange: (input) {
                            setState(() {
                              about = input;
                            }); 
                          },
                        ),
                        const SizedBox(height: 48),
                        ButtonWidget(
                          text: '保存',
                          onClicked: () {
                            SaveData();
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
            }),
      );

  Future<void> SaveData() async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(AuthModel().user.uid)
          .update({
        'name': name,
        'id': id,
        'about': about,
      });
    } catch (e) {
      print("Error");
    }
  }

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
