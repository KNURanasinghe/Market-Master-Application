import 'package:flutter/material.dart';

class CustomHomeTopics extends StatelessWidget {
  String title;
  double fontSize;

   CustomHomeTopics({
    super.key,
    required this.title,
    required this.fontSize, 
  });

  @override
  Widget build(BuildContext context) {
    return  Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Color(0xFF328F45),
        ),
      ),
    );
  }
}
