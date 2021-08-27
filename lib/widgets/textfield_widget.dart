import 'package:flutter/material.dart';

typedef ChangeCallback = void Function(String value);
class TextFieldWidget extends StatefulWidget {
  final int maxLines;
  final String label;
  final String text;
  final ChangeCallback onChange;

  const TextFieldWidget({
    Key key,
    this.maxLines = 1,
    this.label,
    this.text="",
    this.onChange = _myDefaultFunc
  }) : super(key: key);
  static _myDefaultFunc(String value){}

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  final controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.text;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              widget.onChange(value);
            },
            maxLines: widget.maxLines,
          ),
        ],
      );
}
