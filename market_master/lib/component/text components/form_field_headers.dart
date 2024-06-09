import 'package:flutter/material.dart';

class FormFiledHeaders extends StatelessWidget {
  Widget widget;
  FormFiledHeaders({
    super.key,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF008E06).withOpacity(0.4),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: widget,
    );
  }
}
