import 'package:flutter/material.dart';
import 'package:myquitbuddy/models/heartrate.dart';
import 'package:myquitbuddy/repositories/remote/patientRemoteRepository.dart';

class CardsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columns
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 2 / 1.8, // Aspect ratio of the cards
        ),
        itemCount: 1, // 2 columns * 4 rows
        itemBuilder: (BuildContext context, int index) {
          return CustomCard(
            // icon: Icons.favorite,
            // text: 'Card $index',
          );
        },
        shrinkWrap: true, // To limit GridView height
        physics: const NeverScrollableScrollPhysics(), // To disable GridView scrolling
      ),
    );
  }
}

class CustomCard extends StatefulWidget {
  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  
  final PatientRemoteRepository _apiService = PatientRemoteRepository();
  double _avgHeartRate = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHeartRate();
  }

  Future<void> _fetchHeartRate() async {
    try {
      print("fetching heartrate");
      // Get the current date
      final endDate = DateTime.now().subtract(const Duration(days: 1));
      // Get the date 7 days ago
      final startDate = endDate.subtract(const Duration(days: 1));
      final measures = await PatientRemoteRepository.getHeartRateAverages(startDate, endDate);
      print(measures);
      setState(() {
        _avgHeartRate = 0;
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

  // final IconData icon;
  // final String text;

  // const CustomCard({
  //   Key? key,
  //   required this.icon,
  //   required this.text,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
            const SizedBox(height: 16.0),
            Text(
              "text",
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}