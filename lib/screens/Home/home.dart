import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_project/screens/Home/list_add.dart';
import 'package:task_project/widgets/widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List todoList = [
    {
      'title': 'aaa',
      'dl': '',
      'isExpired': true,
    },
    {'title': 'bbb', 'dl': '', 'isExpired': false},
    {'title': 'ccc', 'dl': '', 'isExpired': false},
  ];
  var workingIndex = -1;

  @override
  Widget build(BuildContext context) {
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
                todoList[index]['title'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text(
                'MM/DD n時ｍｍ分  x Day ${(todoList[index]['isExpired']) ? 'past' : 'left'}',
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: (todoList[index]['isExpired'])
                      ? Colors.pinkAccent
                      : Colors.black54,
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
          if (data[0] != null) {
            setState(() {
              todoList
                  .add({'title': data[0], 'dl': 'data[1]', 'isExpired': false});
            });
            print(data[1]);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
