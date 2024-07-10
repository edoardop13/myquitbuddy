import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:myquitbuddy/utils/sqlite_service.dart';

class HeatmapCalendarWidget extends StatefulWidget {
  @override
  _HeatmapCalendarWidgetState createState() => _HeatmapCalendarWidgetState();
}

class _HeatmapCalendarWidgetState extends State<HeatmapCalendarWidget> {
  Map<DateTime, int> _heatmapData = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await SQLiteService.getWeeklyData();
    setState(() {
      _heatmapData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Smoking Heatmap',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            HeatMap(
              datasets: _heatmapData,
              startDate: DateTime.now().subtract(Duration(days: 30)),
              endDate: DateTime.now(),
              colorMode: ColorMode.color,
              defaultColor: Colors.white,
              textColor: Colors.black,
              showColorTip: false,
              showText: true,
              scrollable: true,
              size: 30,
              colorsets: {
                1: Colors.green[100]!,
                3: Colors.green[300]!,
                5: Colors.green[500]!,
                7: Colors.green[700]!,
                9: Colors.green[900]!,
              },
            ),
            SizedBox(height: 16),
            Text(
              'Color intensity indicates the number of cigarettes smoked.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}