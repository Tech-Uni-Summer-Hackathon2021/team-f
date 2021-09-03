import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class TodoAddPage extends StatefulWidget {
  @override
  _TodoAddPageState createState() => _TodoAddPageState();
}

class _TodoAddPageState extends State<TodoAddPage> {
  String _title = '';
  DateTime _dlOb = DateTime.now();
  String _dl = '';
  String _memo = '';

  var formatter = new DateFormat('yyyy/MM/dd HH:mm');

  @override
  Widget build(BuildContext context) {
    _dl = formatter.format(_dlOb);

    return Scaffold(
        appBar: AppBar(
          title: Text('リスト追加'),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Visibility(
                  visible: _title != '',
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: ElevatedButton(
                    child: Text('作成'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.cyan,
                      onPrimary: Colors.white,
                      shape: StadiumBorder(),
                    ),
                    onPressed: () {
                      //print(DateTime.now().toLocal().timeZoneName);
                      if (_title != '') {
                        Navigator.of(context).pop({
                          'title': _title,
                          'dl': _dl,
                          'dlOb': _dlOb,
                          'memo': _memo
                        });
                      }
                    },
                  ),
                )
              ],
            ),
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'タスクを入力してください',
                border: InputBorder.none,
              ),
              onChanged: (String value) {
                setState(() {
                  _title = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(border: InputBorder.none),
              controller: TextEditingController(text: _dl),
              readOnly: true,
              onTap: () {
                DatePicker.showDateTimePicker(context, currentTime: _dlOb,
                    onConfirm: (date) {
                  setState(() {
                    _dlOb = date;
                  });
                });
              },
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'メモ',
                    hintStyle: TextStyle(),
                    border: InputBorder.none),
                maxLines: null,
                expands: false,
                onChanged: (String value) {
                  setState(() {
                    _memo = value;
                  });
                },
              ),
            )
          ],
        ));
  }
}
