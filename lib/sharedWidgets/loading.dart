import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Loading",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
          SizedBox(height: 32),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}