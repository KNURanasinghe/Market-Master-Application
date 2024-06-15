import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor:
          const Color.fromARGB(255, 141, 219, 165).withOpacity(0.7),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text(
              "Demo",
              style: TextStyle(
                  color: Color.fromARGB(255, 250, 250, 250),
                  fontWeight: FontWeight.w900,
                  fontSize: 18),
            ),
            accountEmail: const Text(
              "Demo@gmail.com",
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.w900,
                  fontSize: 18),
            ),
            currentAccountPicture: const CircleAvatar(
              child: ClipOval(
                child: Image(
                  image: AssetImage('lib/assets/logo.png'),
                ),
              ),
            ),
            decoration: BoxDecoration(
                color: const Color(0xFF008E06).withOpacity(0.7),
                image: const DecorationImage(
                    image: AssetImage('lib/assets/profilebackground1.png'),
                    fit: BoxFit.cover)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            child: ListTile(
              leading: const Icon(
                Icons.home,
                color: Color(0xFF008E06),
              ),
              title: const Text('Change profile picture'),
              onTap: () => print('Change profile picture'),
              tileColor: const Color.fromARGB(255, 175, 199, 176),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            child: ListTile(
              leading: const Icon(
                Icons.home,
                color: Color(0xFF008E06),
              ),
              title: const Text('Change profile picture'),
              onTap: () => print('Change profile picture'),
              tileColor: const Color.fromARGB(255, 175, 199, 176),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            child: ListTile(
              leading: const Icon(
                Icons.home,
                color: Color(0xFF008E06),
              ),
              title: const Text('Change profile picture'),
              onTap: () => print('Change profile picture'),
              tileColor: const Color.fromARGB(255, 175, 199, 176),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            child: ListTile(
              leading: const Icon(
                Icons.home,
                color: Color(0xFF008E06),
              ),
              title: const Text('Change profile picture'),
              onTap: () => print('Change profile picture'),
              tileColor: const Color.fromARGB(255, 175, 199, 176),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            child: ListTile(
              leading: const Icon(
                Icons.home,
                color: Color(0xFF008E06),
              ),
              title: const Text('Settings'),
              onTap: () => print('Settings'),
              tileColor: const Color.fromARGB(255, 175, 199, 176),
            ),
          ),
        ],
      ),
    );
  }
}
