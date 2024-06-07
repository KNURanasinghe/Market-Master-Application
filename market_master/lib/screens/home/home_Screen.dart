import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:market_master/component/bottom_nav_bar.dart';
import 'package:market_master/component/customized_divider.dart';
import 'package:market_master/component/drawer.dart';
import 'package:market_master/component/home_shop_filter_buttons.dart';
import 'package:market_master/component/home_topics.dart';
import 'package:market_master/component/message_box_button.dart';
import 'package:market_master/screens/chatScreen/chatScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> ctegoryList = ['Fruits', 'Vegetables', 'All'];
  List<String> shopList = ['ABCD', 'EFGH', 'IJKL'];

  List<Map<String, dynamic>> categoryList = [
    {'name': 'Fruits', 'rating': 4.5},
    {'name': 'Vegetables', 'rating': 3.8},
    {'name': 'All', 'rating': 4.0},
  ];

  double _rating = 0.0;

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rate the Seller'),
          content: RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop();
                print(_rating);
                // Submit the rating to your backend or perform any action you need
              },
            ),
          ],
        );
      },
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const Text('Welcome',
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
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Hey, Alina",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
              width: 365,
              height: 152,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('lib/assets/containerBackground.png'),
                    fit: BoxFit.cover),
              ),
              child: const Padding(
                padding: EdgeInsets.only(left: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Find your Store to buy",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      " everything!",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
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
            CustomHomeTopics(
              title: "Categories",
              fontSize: 20,
            ),
            const SizedBox(
              height: 10,
            ),
            FilterButtons(ctegoryList: ctegoryList),
            const SizedBox(
              height: 10,
            ),
            const CustomDivider(),
            const SizedBox(
              height: 10,
            ),
            CustomHomeTopics(
              title: "Shops",
              fontSize: 20,
            ),
            SingleChildScrollView(
              child: SizedBox(
                height: 300, // Set a specific height for the horizontal list
                child: ListView.builder(
                  itemCount: shopList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          width: double.infinity, // Adjust the width as needed
                          margin: const EdgeInsets.symmetric(
                              vertical:
                                  10), // Add horizontal margin to create space
                          child: GestureDetector(
                            onTap: () {
                              print('clicked ${ctegoryList[index]}');
                            },
                            child: Card(
                                color: const Color(0xFFC8E3C7),
                                child: ListTile(
                                  leading: const Image(
                                    image:
                                        AssetImage('lib/assets/shopImage.png'),
                                    fit: BoxFit.fitHeight,
                                  ),
                                  title: Text(
                                    shopList[index],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    ctegoryList[
                                        index], //TODO: Add category name from db
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        RatingBarIndicator(
                                          rating: categoryList[index]['rating'],
                                          itemBuilder: (context, index) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: 20.0,
                                          direction: Axis.horizontal,
                                        ),
                                        Text(
                                          categoryList[index]['rating']
                                              .toString(),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ]),
                                )),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _showRatingDialog,
              child: const Text('Rate Seller'),
            ),
            const BottomNavBar()
          ],
        ),
      ),
      floatingActionButton: MessageBoxButton(),
    );
  }
}
