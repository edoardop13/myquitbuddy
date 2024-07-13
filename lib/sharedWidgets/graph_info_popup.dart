import 'package:flutter/material.dart';
import 'package:myquitbuddy/screens/statisticsPage.dart';

class GraphInfoPopup extends StatelessWidget {
  GraphInfoPopup(InfoPopupType type, {Key? key}) : type = type, super(key: key);
  InfoPopupType type;
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          maxWidth: MediaQuery.of(context).size.width * 0.95,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (type == InfoPopupType.smokedToday)
                        _buildSection("Cigarettes smoked hourly", [
                          "This graph shows the number of cigarettes you have smoked hourly throughout the current day. ",
                          "The data is updated in real-time, providing you with an accurate representation of your smoking pattern.",
                        ]),
                      if (type == InfoPopupType.heartrate)
                        _buildSection("Heartrate", [
                          "The average number of times your heart beats per minute in the last 7 days.",
                          "A normal resting heart rate for adults ranges from 60 to 100 beats per minute.",
                          "Factors such as age, fitness level and smoke can affect your heart rate.",
                        ]),
                      if (type == InfoPopupType.calories)
                        _buildSection("Calories", [
                          "Calories burnt is the amount of energy your body expends or burns during physical activities or exercise. It is measured in calories and represents the energy content of the food you consume. The number of calories burnt depends on various factors such as the intensity and duration of the activity, your body weight, and metabolism. Regular physical activity and exercise can help you burn calories, maintain a healthy weight, and improve overall fitness."
                        ]),
                      if (type == InfoPopupType.sleep)
                        _buildSection("Sleep", [
                          "Sleep is essential for a person’s health and well-being, according to the National Sleep Foundation (NSF).",
                          "Getting enough sleep can help improve your mood, memory, and overall cognitive function.",
                          "Smoking can negatively impact your sleep quality and duration.",
                          "Nicotine is a stimulant that can interfere with your ability to fall asleep and stay asleep.",
                        ]),
                      if (type == InfoPopupType.distance)
                        _buildSection("Distance", [
                          "The total distance you have traveled in the last 7 days.",
                          "Factors such as age, fitness level and smoke can affect your distance.",
                          "Smoking can negatively impact your fitness level and overall health, which may indirectly affect your ability to cover distance.",
                        ]),
                      if (type == InfoPopupType.heatmap)
                        _buildSection("Smoking heatmap", [
                           "A visual representation that shows the distribution and intensity of your smoking habits.",
                           "The heatmap uses colors to represent the frequency of smoking occurrences",
                           "The more intense the color, the greater the amount of cigarettes smoked on that given day",
                        ]),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // Light grey background
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                        ),
                        child: const Text(
                          "Tracking these factors alongside your smoking habits can provide valuable insights into nicotine's immediate and long-term effects on your body. Use this information to make informed decisions about your health and smoking habits.",
                          style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                            color: Colors.black87, // Slightly darker text for better contrast
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  String getInfoTitle() {
    if (type == InfoPopupType.heartrate) {
      return "Heartrate of Last 7 days";
    } else if (type == InfoPopupType.smokedToday) {
      return "Today's Cigarettes";
    } else if (type == InfoPopupType.calories) {
      return "Calories of Last 7 days";
    } else if (type == InfoPopupType.sleep) {
      return "Sleep of Last 7 days";
    } else if (type == InfoPopupType.distance) {
      return "Distance of Last 7 days";
    } else if (type == InfoPopupType.heatmap) {
      return "Heatmap of Last 30 days";
    } else {
      return "";
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              getInfoTitle(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 28),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("• ", style: TextStyle(fontSize: 18)),
              Expanded(child: Text(item, style: const TextStyle(fontSize: 16))),
            ],
          ),
        )).toList(),
      ],
    );
  }
}