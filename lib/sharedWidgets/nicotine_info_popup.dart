import 'package:flutter/material.dart';

class NicotineInfoPopup extends StatelessWidget {
  const NicotineInfoPopup({Key? key}) : super(key: key);

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
                      _buildSection("Heart Health", [
                        "Increases heart rate and blood pressure",
                        "Constricts blood vessels, reducing oxygen flow",
                        "Contributes to arterial stiffness and plaque buildup",
                        "Elevates risk of heart attack and stroke",
                      ]),
                      _buildSection("Physical Activity", [
                        "Decreases lung capacity and oxygen uptake",
                        "Impairs cardiovascular endurance",
                        "Reduces muscle strength and recovery",
                        "Increases fatigue during exercise",
                      ]),
                      _buildSection("Sleep Quality", [
                        "Disrupts natural sleep-wake cycle",
                        "Increases time to fall asleep",
                        "Reduces total sleep time and deep sleep stages",
                        "Causes more frequent nighttime awakenings",
                        "May exacerbate sleep-disordered breathing",
                      ]),
                      SizedBox(height: 24),
                      Container(
                        padding: EdgeInsets.all(16),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              "Nicotine's Impact on Your Health",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          SizedBox(width: 16),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white, size: 28),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        ...items.map((item) => Padding(
          padding: EdgeInsets.only(left: 16, bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("• ", style: TextStyle(fontSize: 18)),
              Expanded(child: Text(item, style: TextStyle(fontSize: 16))),
            ],
          ),
        )).toList(),
      ],
    );
  }
}