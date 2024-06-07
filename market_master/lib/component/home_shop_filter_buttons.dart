
import 'package:flutter/material.dart';

class FilterButtons extends StatelessWidget {
  const FilterButtons({
    super.key,
    required this.ctegoryList,
  });

  final List<String> ctegoryList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, // Set a specific height for the horizontal list
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ctegoryList.length,
        itemBuilder: (context, index) {
          return Container(
            width: 100, // Set a width for each item
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Card(
              color: const Color(0xFF328F45),
              child: Center(
                child: Text(
                  ctegoryList[index],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
