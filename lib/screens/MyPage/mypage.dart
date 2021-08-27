import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_project/models/auth_model.dart';
import 'package:task_project/widgets/widget.dart';
import '../../models/user_data_model.dart';
import '../../models/user_preference.dart';
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
    final user = UserPreferences.myUser;

    return Scaffold(
      appBar: AppbarMain(title: Text("マイページ"), isAction: false),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 10),
          ProfileWidget(
            imagePath: user.avatar,
            onClicked: () async {},
          ),
          const SizedBox(height: 22),
          buildName(user),
          const SizedBox(height: 24),
          Center(child: buildUpgradeButton()),
          const SizedBox(height: 24),
          NumbersWidget(),
          const SizedBox(height: 48),
          buildAbout(user),
        ],
      ),
    );
  }

  Widget buildName(UserData user) => Column(
        children: [
          Text(
            user.displayName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            "@"+AuthModel().user.uid,
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildUpgradeButton() => ButtonWidget(
        text: 'プロフィール編集',
        onClicked: () {},
      );

  Widget buildAbout(UserData user) => Container(
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
              user.about,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}