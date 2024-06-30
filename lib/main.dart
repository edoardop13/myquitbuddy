import 'package:flutter/material.dart';
import 'package:myquitbuddy/managers/tokenManager.dart';
import 'package:myquitbuddy/sharedWidgets/loading.dart';
import 'package:myquitbuddy/utils/appInterceptor.dart';
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
          if (snapshot.hasData) {
            final showLogin = snapshot.data as bool;
            return showLogin
                ? const LoginPage()
                : const HomePage();
          } else {
            return Scaffold(
                appBar: AppBar(title: const Text("MyQuitBuddy")),
                body: const Loading());
          }
        },
      ),
    );
  }

  Future<bool> showLogin() async {
    final isTokenExpired = await TokenManager.isAccessTokenExpired();
    if (!isTokenExpired) {
      return false;
    }
    final credentialStillValid = await AppInterceptor().refreshToken();
    return !credentialStillValid;
  }
}