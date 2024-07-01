import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  String username = "Nome Cognome";
  bool darkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            BigUserCard(
              userName: "Nome Cognome",
              userProfilePic: AssetImage("assets/logo.png"),
              backgroundColor: Colors.lightBlue,
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
                      setState(() {
                        darkTheme == true
                            ? darkTheme = false
                            : darkTheme = true;
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
                            const Image(image: AssetImage('icon/unipd.png'), width: 100,),
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
                    backgroundColor: Colors.purple,
                  ),
                  title: 'About',
                ),
                SettingsItem(
                  onTap: () {},
                  icons: Icons.exit_to_app_rounded,
                  title: "Sign Out",
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  } //build
}
