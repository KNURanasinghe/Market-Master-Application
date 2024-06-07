
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_master/screens/chatScreen/chatScreen.dart';

class MessageBoxButton extends StatelessWidget {
  const MessageBoxButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 38),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Chatscreen()),
          );
        },
        child: const Icon(
          CupertinoIcons.chat_bubble_text_fill,
          color: Color(0xFF328F45),
          size: 50,
        ),
      ),
    );
  }
}
