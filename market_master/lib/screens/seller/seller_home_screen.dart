import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:market_master/component/background/background_with_app_bar.dart';

class SellerHomeScreen extends StatefulWidget {
  const SellerHomeScreen({super.key});

  @override
  State<SellerHomeScreen> createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> allShops = [
    {
      'name': 'Shop 1',
      'type': 'Grocery',
      'image': 'lib/assets/shop1.png',
      'rating': '4.5',
    },
    {
      'name': 'Shop 2',
      'type': 'Clothing',
      'image': 'lib/assets/shop2.png',
      'rating': '4.8',
    },
    {
      'name': 'Shop 3',
      'type': 'Electronics',
      'image': 'lib/assets/shop3.png',
      'rating': '4.9',
    },
    {
      'name': 'Shop 4',
      'type': 'Bakery',
      'image': 'lib/assets/shop4.png',
      'rating': '4.7',
    },
    {
      'name': 'Shop 5',
      'type': 'Pharmacy',
      'image': 'lib/assets/shop5.png',
      'rating': '4.6',
    },
    // Add more shops as needed
  ];

  List<Map<String, String>> filteredShops = [];

  @override
  void initState() {
    super.initState();
    filteredShops = allShops;
  }

  void _filterShops(String query) {
    setState(() {
      filteredShops = allShops
          .where((shop) =>
              shop['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final topRatedShops = allShops
      ..sort((a, b) => b['rating']!.compareTo(a['rating']!))
      ..take(5)
      ..toList();

    return BodyWithAppBar(
      title: 'Seller Home',
      scaffoldKey: _scaffoldKey,
      widget: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Shops',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterShops,
            ),
            const SizedBox(height: 16.0),
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
              items: topRatedShops.map((shop) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            shop['image']!,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            shop['name']!,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(shop['type']!),
                          Text('Rating: ${shop['rating']}'),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: filteredShops.length,
                itemBuilder: (context, index) {
                  final shop = filteredShops[index];
                  return Card(
                    child: ListTile(
                      leading: Image.asset(
                        shop['image']!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(shop['name']!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(shop['type']!),
                          Text('Rating: ${shop['rating']}'),
                        ],
                      ),
                      trailing: const Icon(Icons.navigate_next),
                      onTap: () {
                        // Handle shop tap
                        print('Tapped on ${shop['name']}');
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
