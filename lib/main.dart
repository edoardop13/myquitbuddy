import 'package:flutter/material.dart';
import 'package:myquitbuddy/managers/tokenManager.dart';
import 'package:myquitbuddy/sharedWidgets/loading.dart';
import 'package:myquitbuddy/utils/appInterceptor.dart';
import 'package:flutter/services.dart';
import 'package:myquitbuddy/screens/home/homePage.dart';
import 'package:myquitbuddy/screens/login/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // The app can be used only vertically
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SharedPreferences.getInstance().then((prefs) {
    var isDarkTheme = prefs.getBool("darkTheme") ?? false;
    return runApp(
      ChangeNotifierProvider<ThemeProvider>(
        child: MyApp(),
        create: (BuildContext context) {
          return ThemeProvider(isDarkTheme);
        },
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, value, child) {
        return MaterialApp(
          title: 'My Quit Buddy',
          theme: value.getTheme(),
          home: FutureBuilder(
            future: showLogin(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final showLogin = snapshot.data as bool;
                return showLogin ? const LoginPage() : const HomePage();
              } else {
                return Scaffold(
                    appBar: AppBar(title: const Text("MyQuitBuddy")),
                    body: const Loading());
              }
            },
          ),
        );
      },
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