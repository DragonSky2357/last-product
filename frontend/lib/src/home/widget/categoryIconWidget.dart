import 'package:flutter/material.dart';

class CategoryIconWidget extends StatefulWidget {
  final String iconPath;
  final String iconLabel;
  const CategoryIconWidget(
      {super.key, required this.iconPath, required this.iconLabel});

  @override
  State<CategoryIconWidget> createState() => _CategoryIconWidgetState();
}

class _CategoryIconWidgetState extends State<CategoryIconWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: IconButton(
            icon: Image.asset(
              widget.iconPath,
            ),
            onPressed: () {},
          ),
        ),
        const SizedBox(height: 10),
        Text(widget.iconLabel)
      ],
    );
  }
}
