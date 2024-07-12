import 'package:flutter/material.dart';
import 'package:myquitbuddy/models/heartrate.dart';
import 'package:myquitbuddy/repositories/remote/patientRemoteRepository.dart';
import 'package:myquitbuddy/screens/home/healthStatsPage.dart';
import 'package:myquitbuddy/sharedWidgets//nicotine_info_popup.dart'; // Import the new file

class CardsGrid extends StatelessWidget {
  const CardsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "About yesterday",
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(width: 8.0),
            IconButton(
              icon: Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
              onPressed: () => _showInfoDialog(context),
            ),
          ],
        ),
        const SizedBox(height: 5.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: <Widget>[
            CustomHRCard(),
            CustomDistanceCard(),
            CustomCaloriesCard(),
            CustomSleepCard(),
          ],
        ),
      ],
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => const NicotineInfoPopup(),
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
    return TextButton(
        style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.centerLeft
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HealthStatsPage()),
        );
      },
      child: SizedBox(
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
    return TextButton(
        style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.centerLeft
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HealthStatsPage()),
        );
      },
      child: SizedBox(
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
    return TextButton(
        style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.centerLeft
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HealthStatsPage()),
        );
      },
      child: SizedBox(
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
                  Icons.local_fire_department,
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
    return TextButton(
        style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.centerLeft
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HealthStatsPage()),
        );
      },
      child: SizedBox(
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
      )
    );
  }
}