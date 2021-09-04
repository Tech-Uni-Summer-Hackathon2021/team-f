import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_project/screens/Home/list_add.dart';
import 'package:task_project/widgets/widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_project/models/auth_model.dart';
//import package:task_project/widgets/list_add.dart';

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List todoList = [];
  var workingIndex = -1;
  Map todo;
  DateTime now = DateTime.now();
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    print(getData());
    return Scaffold(
      backgroundColor: Color(int.parse("0xfff0ffff")),
      appBar: AppbarMain(
        title: Text("タスクリスト"),
        isAction: true,
      ),
      drawer: drawerMain(context),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          todo = todoList[index];
          todo['isExpired'] = todo['dlOb'].isBefore(now);
          return Card(
              child: Slidable(
            actionPane: SlidableStrechActionPane(),
            actionExtentRatio: 0.2,
            actions: [
              IconSlideAction(
                caption: 'Complete!',
                icon: Icons.assignment_turned_in_outlined,
                color: Colors.lightGreen,
                foregroundColor: Colors.white,
              )
            ],
            secondaryActions: [
              IconSlideAction(
                caption: 'Delete',
                icon: Icons.delete,
                color: Colors.red,
                foregroundColor: Colors.white,
                onTap: () => setState(() => todoList.removeAt(index)),
              )
            ],
            child: ListTile(
              selected: (index == workingIndex) ? true : false,
              selectedTileColor: Colors.greenAccent,
              leading: Icon(
                Icons.check_circle_outline,
                color: Colors.black12,
                size: 24,
              ),
              title: Text(
                todo['title'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(
                '${todo['dl']}  x Day ${(todo['isExpired']) ? 'past' : 'left'}',
                textAlign: TextAlign.end,
                style: TextStyle(
                  color:
                      (todo['isExpired']) ? Colors.pinkAccent : Colors.black54,
                ),
              ),
              onTap: () => setState(() => workingIndex = index),
              onLongPress: () => setState(() {
                if (workingIndex == index) {
                  workingIndex = -1;
                }
              }),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            ),
          ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final data = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return TodoAddPage();
            }),
          );
          if (data != null) {
            data['isExpired'] = false;
            setState(() {
              todoList.add(data);
            });

            var docRef = await _firestore
                .collection("usersTask")
                .doc(AuthModel().user.uid)
                .set({'data': todoList});
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

getData() async {
  var x = await FirebaseFirestore.instance
      .collection("usersTask")
      .doc(AuthModel().user.uid)
      .get()
      .then((value) => value.data());
  print(x);
  return x;
}
