import 'package:flutter/material.dart';
import 'package:market_master/component/background/background_with_app_bar.dart';
import 'package:market_master/component/customized_divider.dart';
import 'package:market_master/component/text%20components/custom_text_components.dart';

class FarmerHomeScreen extends StatefulWidget {
  const FarmerHomeScreen({super.key});

  @override
  State<FarmerHomeScreen> createState() => _FarmerHomeScreenState();
}

class _FarmerHomeScreenState extends State<FarmerHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BodyWithAppBar(
      title: 'Farmer Home',
      scaffoldKey: _scaffoldKey,
      widget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                width: 365,
                height: 152,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/assets/farmercont.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextComponent(
                        text: 'Sell your harvest',
                        fw: FontWeight.bold,
                        fz: 20,
                      ),
                      CustomTextComponent(
                        text: 'OR',
                        fw: FontWeight.bold,
                        fz: 20,
                      ),
                      CustomTextComponent(
                        text: 'Choose Market place',
                        fw: FontWeight.bold,
                        fz: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const CustomDivider(),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              width: 365,
              decoration: BoxDecoration(
                  color: const Color(0xFFB6FAA6).withOpacity(0.73),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Center(
                child: CustomTextComponent(
                  text: "Available bids",
                  fw: FontWeight.w800,
                  fz: 22,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
