import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:myquitbuddy/managers/tokenManager.dart';
import 'package:myquitbuddy/screens/home/homePage.dart';
import 'package:myquitbuddy/repositories/remote/authRemoteRepository.dart';
import 'package:myquitbuddy/repositories/remote/patientRemoteRepository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String? _username;
  String? _password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("MyQuitBuddy"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icon/icon.png', height: 120),
                  const SizedBox(height: 15.0),
                  const Text("Login", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 5.0),
                  const Text("Please login to continue", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15)),
                  const SizedBox(height: 15.0),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Username', icon: Icon(Icons.person)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onSaved: (value) => _username = value!,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Password', icon: Icon(Icons.password)),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      final success = await login(context, _username!, _password!);
                      if (success && context.mounted) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                      } else if (context.mounted) {
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(content: Text('Invalid credential')),
                          );
                      }
                    }
              })
            ]),
          ),
        ));
  }

  Future<bool> login(
    BuildContext context,
    String username,
    String password,
  ) async {
    if (username.isEmpty || password.isEmpty) {
      return false;
    }
    final result = await AuthRemoteRepository.login(username, password);
    if (result) {
      final patients = await PatientRemoteRepository.getPatients();
      if (patients == null) {
        return false;
      }
      final myPatient = patients.first;
      await TokenManager.saveUsername(myPatient);
      // if (context.mounted) {
      //   Provider.of<DatabaseRepository>(context, listen: false)
      //       .addPersonIfNotPresent(Person(
      //     myPatient.username,
      //     myPatient.displayName,
      //     myPatient.birthYear,
      //   ));
      // }
    }
    return result;
  }
}
