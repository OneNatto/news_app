import 'package:flutter/material.dart';
import '../screens/screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.home,
              color: Colors.white,
            ),
            title: const Text("ホーム"),
            onTap: () {
              Navigator.pushNamed(
                context,
                HomeScreen.routeName,
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            title: const Text("検索"),
            onTap: () {
              Navigator.pushNamed(
                context,
                DiscoverScreen.routeName,
              );
            },
          ),
        ],
      ),
    );
  }
}
