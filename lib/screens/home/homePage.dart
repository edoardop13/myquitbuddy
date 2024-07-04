import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myquitbuddy/screens/home/cigaretteTracker.dart';
import 'package:myquitbuddy/screens/profilePage.dart';
import 'package:myquitbuddy/screens/statisticsPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyQuitBuddy',
        style: TextStyle(
          color: Color(0xFF007F9F),
          fontWeight: FontWeight.bold,
        ),),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        indicatorColor: Color(0xFF007F9F),
        selectedIndex: selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.add_box_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Statistics',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        children: [ProfilePage(), StatisticsPage(), ProfilePage()],
        onPageChanged: (index) => setState(() {
          selectedIndex = index;
        }),
      ),
    );
  }
}
