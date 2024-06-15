import 'package:flutter/material.dart';
import 'package:market_master/component/background/background_with_app_bar.dart';
import 'package:market_master/component/customized_divider.dart';
import 'package:market_master/component/text%20components/custom_text_components.dart';
import 'package:market_master/screens/farmer/open_bid_form.dart';

class FarmerHomeScreen extends StatefulWidget {
  const FarmerHomeScreen({super.key});

  @override
  State<FarmerHomeScreen> createState() => _FarmerHomeScreenState();
}

class _FarmerHomeScreenState extends State<FarmerHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Sample data for available bids
  final List<Map<String, String>> bids = [
    {
      'title': 'Bid 1',
      'subtitle': 'Details of bid 1',
    },
    {
      'title': 'Bid 2',
      'subtitle': 'Details of bid 2',
    },
    // Add more bids as needed
    {
      'title': 'Bid 3',
      'subtitle': 'Details of bid 3',
    },
    {
      'title': 'Bid 4',
      'subtitle': 'Details of bid 4',
    },
    {
      'title': 'Bid 5',
      'subtitle': 'Details of bid 5',
    },
    {
      'title': 'Bid 6',
      'subtitle': 'Details of bid 6',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BodyWithAppBar(
      title: 'Farmer Home',
      scaffoldKey: _scaffoldKey,
      widget: SingleChildScrollView(
        child: Padding(
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
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
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
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                  child: CustomTextComponent(
                    text: "Available bids",
                    fw: FontWeight.w800,
                    fz: 22,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bids.length,
                itemBuilder: (context, index) {
                  final bid = bids[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: const Icon(Icons.abc),
                      title: Text(bid['title']!),
                      subtitle: Text(bid['subtitle']!),
                      trailing: const Icon(Icons.navigate_next),
                      tileColor: const Color(0xFFB6FAA6).withOpacity(0.5),
                      onTap: () {
                        // Add your onTap code here!
                        print('Tapped on ${bid['title']}');
                      },
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OpenBidForm(),
                      ));
                },
                child: Container(
                  height: 50,
                  width: 365,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB6FAA6).withOpacity(0.73),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 40,
                      ),
                      const Icon(Icons.add_box_outlined),
                      const SizedBox(
                        width: 40,
                      ),
                      CustomTextComponent(
                        text: "Open a Bid",
                        fw: FontWeight.w800,
                        fz: 22,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () => {},
                child: Container(
                  height: 50,
                  width: 365,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB6FAA6).withOpacity(0.73),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 40,
                      ),
                      const Icon(Icons.history_outlined),
                      const SizedBox(
                        width: 40,
                      ),
                      CustomTextComponent(
                        text: "Bid History",
                        fw: FontWeight.w800,
                        fz: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
