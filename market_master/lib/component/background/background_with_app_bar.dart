import 'package:flutter/material.dart';
import 'package:market_master/component/drawer/drawer.dart';

class BodyWithAppBar extends StatelessWidget {
  String title;
  Widget widget;
   BodyWithAppBar({
    super.key,
    required GlobalKey<ScaffoldState> scaffoldKey,
    required this.widget,
    required this.title,
  }) : _scaffoldKey = scaffoldKey;

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      drawer: const NavBar(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 2, top: 2),
              child: Image.asset(
                'lib/assets/logo.png', // Replace with your logo asset path
                height: 50, // Adjust the height as needed
              ),
            ),
             Text(title,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF328F45))),
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: Color(0xFF328F45),
                size: 30,
              ),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          ],
        ),
        backgroundColor: const Color(0xFFC8E3C7), // Custom background color
      ),
      backgroundColor: const Color(0xFFE1EEDE),
      body: widget,
    ));
  }
}
