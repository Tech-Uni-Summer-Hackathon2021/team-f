import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_project/models/auth_model.dart';
import 'package:task_project/widgets/widget.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/numbers_widget.dart';
import '../../widgets/profile_widget.dart';

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
                          imagePath:
                              snapshot.data['avatar_image_path'],
                          onClicked: () async {},
                        ),
                        const SizedBox(height: 22),
                        buildName(snapshot.data['name'],
                            snapshot.data['id']),
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
        onClicked: () {},
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
}
