import 'package:flutter/material.dart';

class CustomTextComponent extends StatelessWidget {
  String text;
  double? fz;
  FontWeight? fw;
  Color? color;
  CustomTextComponent({
    super.key,
    required this.text,
    this.fz,
    this.fw,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: fz, fontWeight: fw, color: color),
    );
  }
}
