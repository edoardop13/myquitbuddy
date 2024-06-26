import 'package:flutter/material.dart';
import 'cardsGrid.dart';
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CircularIconButton(
              onPressed: _incrementCounter,
              icon: const Icon(
                Icons.smoking_rooms,
                size: 50,
                color: Colors.white,
              ),
              size: 100,
              backgroundColor: _getColor(),
            ),
            const SizedBox(height: 15),
            Expanded( // Use Expanded here
              child: CardsGrid(), // Integrating the Grid here
            ),
          ],
        ),
      ),
    );
  } //build
}

class CircularIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final double size;
  final Color backgroundColor;

  const CircularIconButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.size = 50.0,
    this.backgroundColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: backgroundColor, // Button color
        child: InkWell(
          splashColor: Theme.of(context).primaryColorLight, // Splash color
          onTap: onPressed,
          child: SizedBox(
            width: size,
            height: size,
            child: Center(
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}