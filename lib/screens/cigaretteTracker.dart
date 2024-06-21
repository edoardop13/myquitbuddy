import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CigaretteTracker extends StatefulWidget {
  @override
  _CigaretteTrackerState createState() => _CigaretteTrackerState();
}

class _CigaretteTrackerState extends State<CigaretteTracker> {
  int _cigaretteCount = 0;

  void _incrementCounter() {
    setState(() {
      if (_cigaretteCount < 100) _cigaretteCount++;
    });
  }

  Color _getColor() {
    if (_cigaretteCount < 3) {
      return Colors.green;
    } else if (_cigaretteCount < 6) {
      return Colors.orange;
    } else if (_cigaretteCount < 9) {
      return Colors.red;
    } else
      return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Tooltip(
              message: "Press button to add a smoked cigarette",
              child: InkWell(
                onTap: _incrementCounter,
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: _getColor(),
                  child: const Icon(
                    Icons.smoking_rooms,
                    color: Colors.white,
                    size: 70,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            LinearPercentIndicator(
              lineHeight: 16.0,
              percent: (_cigaretteCount.toDouble() <= 10
                      ? (_cigaretteCount.toDouble())
                      : 10) *
                  0.1,
              backgroundColor: Colors.grey,
              progressColor: _getColor(),
            ),
            const SizedBox(height: 60),
            Text(
              '$_cigaretteCount',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: _getColor(),
              ),
            ),
          ],
        ),
      ),
    );
  } //build
}