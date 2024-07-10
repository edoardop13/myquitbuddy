import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:myquitbuddy/managers/tokenManager.dart';
import 'package:myquitbuddy/repositories/remote/patientRemoteRepository.dart';
import 'package:myquitbuddy/screens/login/loginPage.dart';
import 'package:myquitbuddy/theme.dart';
import 'package:provider/provider.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  String username = "Username";
  bool darkTheme = false;

  // This is done to set the correct position for the theme switch selector
  @override
  void initState() {
    darkTheme = Provider.of<ThemeProvider>(context, listen: false).isDarkSelected();
    loadUsername();
  }

  Future<void> loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Username';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            SimpleUserCard(
              userName: username,
              userProfilePic: const AssetImage('profile.jpg'),
              imageRadius: 50,
              textStyle: const TextStyle(fontSize: 40),
            ),
            SettingsGroup(
              items: [
                SettingsItem(
                  onTap: () {},
                  icons: Icons.dark_mode_rounded,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.red,
                  ),
                  title: 'Dark mode',
                  trailing: Switch.adaptive(
                    value: darkTheme,
                    onChanged: (value) {
                      Provider.of<ThemeProvider>(context, listen: false).swapTheme();
                      value = true;
                      setState(() {
                        if (darkTheme) {
                          darkTheme = false;
                        } else {
                          darkTheme = true;
                        }
                      });
                    },
                  ),
                ),
                SettingsItem(
                  onTap: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Image(
                              image: AssetImage('icon/unipd.png'),
                              width: 100,
                            ),
                            const SizedBox(height: 10),
                            const Text('MyQuitBuddy',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            RichText(
                              text: TextSpan(
                                text:
                                    'Application created for the Biomedical Wearable Technologies for Healthcare and Wellbeing class.\nUniversity of Padova\nAcademic year 2023-2024\n©MEA Group',
                                style: DefaultTextStyle.of(context).style,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 15),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  icons: Icons.info_rounded,
                  iconStyle: IconStyle(
                    backgroundColor: Colors.lightBlue,
                  ),
                  title: 'About',
                ),
                SettingsItem(
                  onTap: () async {
                    if (await confirm(
                      context,
                      title: const Text('Sign out'),
                      content: const Text('Are you sure you want to sign out?'),
                      textOK: const Text('Sign out'),
                      textCancel: const Text('Cancel'),
                    )) {
                      TokenManager.clearTokens();
                      Navigator.of(context)
                          .popUntil(ModalRoute.withName('/login'));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    }
                  },
                  icons: Icons.exit_to_app_rounded,
                  title: "Sign out",
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  } //build
}
