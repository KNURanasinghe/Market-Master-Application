import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:market_master/component/customized_divider.dart';
import 'package:market_master/component/drawer/drawer.dart';
import 'package:market_master/component/home_shop_filter_buttons.dart';
import 'package:market_master/component/home_topics.dart';
import 'package:market_master/component/message_box_button.dart';
import 'package:market_master/controller/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  List<dynamic> _users = [];
  late String _currentUserName = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _fetchCurrentUser();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final users =
          await Provider.of<AuthProvider>(context, listen: false).getAllUsers();
      setState(() {
        _users = users;
      });
    } catch (error) {
      // Handle error here, e.g., show a dialog
      print(error); // For debugging purposes
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      print('Token in _fetchCurrentUser: $token'); // Debug print
      final userId = Provider.of<AuthProvider>(context, listen: false)
          .getUserIdFromToken(token);
      print('User ID in _fetchCurrentUser: $userId'); // Debug print

      if (userId.isNotEmpty) {
        final user = await Provider.of<AuthProvider>(context, listen: false)
            .fetchUserById(userId);
        setState(() {
          _currentUserName =
              user['name'] ?? ''; // Fallback to empty string if 'name' is null
          print('Current User Name: $_currentUserName'); // Debug print
        });
      } else {
        print('User ID is empty');
      }
    } catch (error) {
      print('Error fetching current user: $error');
      // Handle error, e.g., show a dialog
    }
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rate the Seller'),
          content: RatingBar.builder(
            initialRating: 0.0,
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
              // Handle rating update
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
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          // Assuming you want to display the name of the first user
                          _users.isNotEmpty
                              ? "Hey, $_currentUserName"
                              : 'Hey, there!',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
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
                        width: 365,
                        height: 152,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'lib/assets/containerBackground.png'),
                              fit: BoxFit.cover),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 60),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Find your Store to buy",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                " everything!",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
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
                      const FilterButtons(ctegoryList: [
                        'Fruits',
                        'Vegetables',
                        'All'
                      ]), // Update with your dynamic categories
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
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _users.length,
                        itemBuilder: (context, index) {
                          final user = _users[index];
                          return Column(
                            children: [
                              Container(
                                width: double
                                    .infinity, // Adjust the width as needed
                                margin: const EdgeInsets.symmetric(
                                    vertical:
                                        10), // Add horizontal margin to create space
                                child: GestureDetector(
                                  onTap: () {
                                    // Handle shop click
                                    print('Clicked shop: ${user['shop_name']}');
                                  },
                                  child: Card(
                                      color: const Color(0xFFC8E3C7),
                                      child: ListTile(
                                        leading: const Image(
                                          image: AssetImage(
                                              'lib/assets/shopImage.png'),
                                          fit: BoxFit.fitHeight,
                                        ),
                                        title: Text(
                                          user['shop_name'] ?? 'no name',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          user['type_of_goods'] ??
                                              'Unknown Category',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        trailing: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              RatingBarIndicator(
                                                rating: user['rating'] ?? 0.0,
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
                                                user['rating'] != null
                                                    ? user['rating'].toString()
                                                    : 'N/A',
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ]),
                                      )),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      ElevatedButton(
                        onPressed: _showRatingDialog,
                        child: const Text('Rate Seller'),
                      ),
                    ],
                  ),
                ),
              ),
        floatingActionButton: const MessageBoxButton(),
      ),
    );
  }
}
