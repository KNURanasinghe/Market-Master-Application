import 'dart:async';

import 'package:flutter/material.dart';
import 'package:market_master/screens/home/home_Screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.85)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 300),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF102d16).withOpacity(0.4),
                    const Color(0xFF1b4e26).withOpacity(0.36),
                    const Color(0xFF1a4b24).withOpacity(0.33),
                    const Color(0xFF008e06).withOpacity(0.58),
                  ],
                  stops: const [0.0, 0.17, 0.39, 0.88],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 200.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('lib/assets/logo.png'),
                        fit: BoxFit.cover,
                      ),
                      Image(
                        image: AssetImage('lib/assets/Name.png'),
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Text('© 2024 All rights reserved',
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                    Text('Developed by Flutter Developer Com22',
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                    SizedBox(height: 15),
                    Text('Privacy Policy | Terms of Service | Contact Us',
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                    Text('Follw us on Facebook Instergram Twitter',
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
