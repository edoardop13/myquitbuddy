import 'package:flutter/material.dart';

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
          childAspectRatio: 3 / 2, // Aspect ratio of the cards
        ),
        itemCount: 8, // 2 columns * 4 rows
        itemBuilder: (BuildContext context, int index) {
          return CustomCard(
            icon: Icons.favorite,
            text: 'Card $index',
          );
        },
        shrinkWrap: true, // To limit GridView height
        physics: const NeverScrollableScrollPhysics(), // To disable GridView scrolling
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const CustomCard({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

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
              icon,
              size: 48.0,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16.0),
            Text(
              text,
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