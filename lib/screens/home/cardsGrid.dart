import 'package:flutter/material.dart';
import 'package:myquitbuddy/models/heartrate.dart';
import 'package:myquitbuddy/repositories/remote/patientRemoteRepository.dart';

class CardsGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0, // gap between adjacent chips
        runSpacing: 4.0, // gap between lines
        children: <Widget>[
          CustomHRCard(),
          CustomDistanceCard(),
          CustomCaloriesCard(),
          CustomSleepCard(),
        ],
      )
    );
  }
}

class CustomHRCard extends StatefulWidget {
  @override
  _CustomCardHRState createState() => _CustomCardHRState();
}

class _CustomCardHRState extends State<CustomHRCard> {
  
  final PatientRemoteRepository _apiService = PatientRemoteRepository();
  String _avgHeartRate = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Get the current date
      final endDate = DateTime.now().subtract(const Duration(days: 1));
      // Get the date 7 days ago
      final startDate = endDate.subtract(const Duration(days: 7));
      final measures = await PatientRemoteRepository.getHeartRateAverages(startDate, endDate);
      setState(() {
        _avgHeartRate = measures?.last['average_heart_rate'].toStringAsFixed(2);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load posts')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth / 2 - 50;
    return SizedBox(
      width: cardWidth,
      height: 150.0,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4, // Shadow depth
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite,
                size: 48.0,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 6.0),
              const Text(
                "Heart Rate",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Avg: $_avgHeartRate bpm",
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDistanceCard extends StatefulWidget {
  @override
  _CustomCardDistanceState createState() => _CustomCardDistanceState();
}

class _CustomCardDistanceState extends State<CustomDistanceCard> {
  
  final PatientRemoteRepository _apiService = PatientRemoteRepository();
  int _distance = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Get the yesterday date
      final date = DateTime.now().subtract(const Duration(days: 1));
      final distance = await PatientRemoteRepository.getDayTotalDistance(date);
      setState(() {
        _distance = distance ?? 0;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load posts')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth / 2 - 50;
    return SizedBox(
      width: cardWidth,
      height: 150.0,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4, // Shadow depth
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.directions_walk,
                size: 48.0,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 6.0),
              const Text(
                "Distance",
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$_distance",
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class CustomCaloriesCard extends StatefulWidget {
  @override
  _CustomCardCaloriesState createState() => _CustomCardCaloriesState();
}

class _CustomCardCaloriesState extends State<CustomCaloriesCard> {
  
  final PatientRemoteRepository _apiService = PatientRemoteRepository();
  String _calories = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Get the yesterday date
      final date = DateTime.now().subtract(const Duration(days: 1));
      final calories = await PatientRemoteRepository.getDayTotalCalories(date);
      setState(() {
        _calories = calories?.toStringAsFixed(2) ?? "";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load posts')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth / 2 - 50;
    return SizedBox(
      width: cardWidth,
      height: 150.0,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4, // Shadow depth
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.directions_walk,
                size: 48.0,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 6.0),
              const Text(
                "Calories",
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$_calories kcal",
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class CustomSleepCard extends StatefulWidget {
  @override
  _CustomCardSleepState createState() => _CustomCardSleepState();
}

class _CustomCardSleepState extends State<CustomSleepCard> {
  
  final PatientRemoteRepository _apiService = PatientRemoteRepository();
  String _sleep = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Get the yesterday date
      final date = DateTime.now().subtract(const Duration(days: 1));
      final sleep = await PatientRemoteRepository.getDayTotalSleep(date) ?? 0;
      setState(() {
        _sleep = (sleep / 60).toStringAsFixed(2);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load posts')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth / 2 - 50;
    return SizedBox(
      width: cardWidth,
      height: 150.0,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4, // Shadow depth
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.bedtime,
                size: 48.0,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 6.0),
              const Text(
                "Sleep",
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$_sleep hours",
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}