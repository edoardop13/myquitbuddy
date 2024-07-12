import 'package:flutter/material.dart';
import 'dart:async';
import 'cardsGrid.dart';
import 'package:myquitbuddy/utils/sqlite_service.dart';

class CigaretteTracker extends StatefulWidget {
  @override
  _CigaretteTrackerState createState() => _CigaretteTrackerState();
}

class _CigaretteTrackerState extends State<CigaretteTracker> {
  int _cigaretteCount = 0;
  DateTime? _lastIncrementTime;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    String today = DateTime.now().toIso8601String().substring(0, 10);
    Map<String, int> counts = await SQLiteService.getCigaretteCounts(today);

    setState(() {
      _cigaretteCount = counts.values.fold(0, (sum, count) => sum + count);
    });
  }

  void _incrementCounter() {
    setState(() {
      if (_cigaretteCount < 100) {
        _cigaretteCount++;
        _lastIncrementTime = DateTime.now();
        SQLiteService.incrementCigaretteCount(_lastIncrementTime!);
      }
    });
    _showSnackBar(_getMessage());
  }

  void _undoAction() {
    if (_lastIncrementTime != null) {
      setState(() {
        _cigaretteCount--;
        SQLiteService.decrementCigaretteCount(_lastIncrementTime!);
        _lastIncrementTime = null;
      });
    }
  }

  Color _getColor() {
    if (_cigaretteCount < 1) {
      return Colors.green;
    }
    else if (_cigaretteCount < 3) {
      return const Color.fromARGB(255, 253, 230, 25);
    } else if (_cigaretteCount < 6) {
      return Colors.orange;
    } else if (_cigaretteCount < 9) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  String _getMessage() {
    if (_cigaretteCount < 3) {
      return "Try to smoke less!";
    } else if (_cigaretteCount < 6) {
      return "It's getting unhealthy!";
    } else if (_cigaretteCount < 9) {
      return "You should stop smoking!";
    } else {
      return "Please seek help to quit smoking!";
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text('Cigarette count incremented. $message'),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: _undoAction,
        textColor: Colors.blue,
      ),
      backgroundColor: Colors.grey[800],
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Non-scrollable part
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircularIconButton(
                  onPressed: _incrementCounter,
                  icon: const Icon(
                    Icons.smoking_rooms,
                    size: 80,
                    color: Colors.white,
                  ),
                  size: 200,
                  backgroundColor: _getColor(),
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
                const SizedBox(height: 16.0),
                _cigaretteCount == 0
                    ? Text(
                  'Still no cigarettes today! Keep it up',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                )
                    : RichText(
                  text: TextSpan(
                    text: 'Cigarettes smoked today: ',
                    style: Theme.of(context).textTheme.titleLarge,
                    children: <TextSpan>[
                      TextSpan(
                        text: '$_cigaretteCount',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Scrollable part wrapped in a card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                        offset: Offset(0.0, 5.0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: CardsGrid(),
                    ),
                  ),
                ),
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
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            offset: Offset(-6.0, -6.0),
            blurRadius: 16.0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(6.0, 6.0),
            blurRadius: 16.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: CircleBorder(),
          splashColor: Theme.of(context).primaryColorLight.withOpacity(0.5),
          onTap: onPressed,
          child: Center(
            child: icon,
          ),
        ),
      ),
    );
  }
}