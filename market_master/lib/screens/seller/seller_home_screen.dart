import 'package:flutter/material.dart';
import 'package:market_master/component/background/background_with_app_bar.dart';

class SellerHomeScreen extends StatefulWidget {
  const SellerHomeScreen({super.key});

  @override
  State<SellerHomeScreen> createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BodyWithAppBar(
      title: 'Seller Home',
      scaffoldKey: _scaffoldKey,
      widget: const Column(),
    );
  }
}
