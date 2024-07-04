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
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Center(
              child: CircularIconButton(
                onPressed: _incrementCounter,
                icon: const Icon(
                  Icons.smoking_rooms,
                  size: 80,
                  color: Colors.white,
                ),
                size: 200,
                backgroundColor: _getColor(),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Cigarettes smoked today: $_cigaretteCount',
                      style: Theme.of(context).textTheme.titleLarge,  // Changed from headline6 to titleLarge
                    ),
                  ),
                  CardsGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(
          child: Material(
            color: backgroundColor,
            child: InkWell(
              splashColor: Theme.of(context).primaryColorLight,
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
        ),
        const SizedBox(height: 16.0),
        Text(
          'Press the button every time you smoke',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}