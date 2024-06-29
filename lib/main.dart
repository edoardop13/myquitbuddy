import 'package:flutter/material.dart';
import 'screens/home/cigaretteTracker.dart';
import 'screens/profilePage.dart';
import 'package:flutter/services.dart';
import 'package:myquitbuddy/screens/home/homePage.dart';
import 'package:myquitbuddy/screens/login/loginPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // The app can be used only vertically
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Quit Buddy',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.light,
        ),
        primaryColor: Colors.blueGrey,
      ),
      home: FutureBuilder(
        future: showLogin(),
        builder:(context, snapshot) {
          if(snapshot.hasData) {
            return const HomePage();
            // return snapshot.hasData ? LoginPage() : const HomePage(); // TODO: gestione login
          } else {
            return Scaffold(
              appBar: AppBar(title: const Text('MyQuitBuddy')), body: null
            );
          }
        },
      ),
    );
  }

  Future<bool> showLogin() async {
    //TODO: gestione token e login
    return true;
  }
}