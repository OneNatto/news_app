import 'package:flutter/material.dart';
import 'package:news_app_ui/screens/discover_screen.dart';
import 'package:news_app_ui/screens/home_screen.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.5;
    return BottomNavigationBar(
      currentIndex: index,

      //新しい知識
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withAlpha(100),
      //ここまで

      items: [
        //ホーム
        BottomNavigationBarItem(
          icon: SizedBox(
            width: width,
            height: 40,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  HomeScreen.routeName,
                );
              },
              child: const Center(
                child: Icon(Icons.home),
              ),
            ),
          ),
          label: "ホーム",
        ),
        //検索
        BottomNavigationBarItem(
          icon: SizedBox(
            width: width,
            height: 40,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  DiscoverScreen.routeName,
                );
              },
              child: const Center(
                child: Icon(Icons.search),
              ),
            ),
          ),
          label: "検索",
        ),
      ],
    );
  }
}
