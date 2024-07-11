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
        itemCount: 4, // 2 columns * 4 rows
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
  List<Heartrate> _measures = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHeartRate();
  }

  Future<void> _fetchHeartRate() async {
    try {
      print("fetching heartrate");
      final measures = await PatientRemoteRepository.getHeartrate(DateTime.now());
      print("Here");
      print(measures);
      setState(() {
        _measures = measures ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load posts')),
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
              _measures.fold(0, (sum, item) => sum + item.value).toString(),
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