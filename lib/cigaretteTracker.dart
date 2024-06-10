import 'package:flutter/material.dart';

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
    if (_cigaretteCount < 30) {
      return Colors.green;
    } else if (_cigaretteCount < 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _incrementCounter, 
              child: CircleAvatar(
                radius: 50,
                backgroundColor: _getColor(),
                child: Icon(
                  Icons.smoking_rooms,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              style: ElevatedButton.styleFrom(
                // foregroundColor: Colors.white, backgroundColor: _getColor(), // Foreground color
                shape: CircleBorder(),
                // padding: EdgeInsets.all(5),
              ) 
            ),
            // CircleAvatar(
            //   radius: 50,
            //   backgroundColor: _getColor(),
            //   onPressed: _incrementCounter,
            //   child: Icon(
            //     Icons.smoking_rooms,
            //     color: Colors.white,
            //     size: 50,
            //   ),
            // ),
            SizedBox(height: 15),
            Slider(
              value: _cigaretteCount.toDouble(),
              min: 0,
              max: 100,
              divisions: 100,
              activeColor: _getColor(),
              inactiveColor: Colors.grey,
              onChanged: (double value) {},
            ),
            Text(
              '$_cigaretteCount',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _getColor(),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: Icon(Icons.add),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: _getColor(), // Foreground color
                shape: CircleBorder(),
                padding: EdgeInsets.all(24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}