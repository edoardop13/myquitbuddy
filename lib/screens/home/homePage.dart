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
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
          pageController.jumpToPage(index);
        },
        indicatorColor: Color.fromARGB(255, 0, 185, 231),
        selectedIndex: selectedIndex,
        destinations: <Widget>[
          _buildNavigationDestination(Icons.add_box_outlined, 'Home', 0),
          _buildNavigationDestination(Icons.calendar_month_outlined, 'Statistics', 1),
          _buildNavigationDestination(Icons.person, 'Profile', 2),
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

  Widget _buildNavigationDestination(IconData icon, String label, int index) {
    return NavigationDestination(
      icon: Icon(
        icon,
        color: selectedIndex == index ? Colors.white : null,
      ),
      label: label,
    );
  }
}