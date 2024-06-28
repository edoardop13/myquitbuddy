import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myquitbuddy/screens/cigaretteTracker.dart';
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
        title: const Text('MyQuitBuddy'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Profile',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index) => pageController.animateToPage(index,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInToLinear),
      ),
      body: PageView(
        controller: pageController,
        children: [CigaretteTracker(), StatisticsPage(), ProfilePage()],
        onPageChanged: (index) => setState(() {
          selectedIndex = index;
        }),
      ),
    );
  }
}
