import 'package:flutter/material.dart';
import 'package:frontend/src/account/widget/LoginWidget.dart';

class TextFieldWidget extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController textEditingController;
  final bool obscureText;
  final TextInputType textInputType;

  const TextFieldWidget(
      {super.key,
      required this.label,
      required this.hintText,
      required this.textEditingController,
      this.obscureText = false,
      this.textInputType = TextInputType.text});

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(widget.label,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: widget.textEditingController,
            obscureText: widget.obscureText,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              hintText: widget.hintText,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '${widget.label} 입력하세요';
              }
              return null;
            },
            onChanged: (value) {},
            keyboardType: widget.textInputType,
          )
        ]);
  }
}
