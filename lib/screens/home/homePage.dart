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
        title: const Text('MyQuitBuddy'),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.add_box_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon:  Icon(Icons.person),
            label: 'Messages',
          ),
        ],
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
