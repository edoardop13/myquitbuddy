import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  String username = "Nome Cognome";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: [
                  // User card
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
                          value: false,
                          onChanged: (value) {},
                        ),
                      ),
                      SettingsItem(
                        onTap: () {},
                        icons: Icons.exit_to_app_rounded,
                        title: "Sign Out",
                      ),
                      SettingsItem(
                        onTap: () {},
                        icons: Icons.info_rounded,
                        iconStyle: IconStyle(
                          backgroundColor: Colors.purple,
                        ),
                        title: 'About',
                      ),
                    ],
                  ),
                ],
              ),
            ),
        
      
    ));
  } //build
}
