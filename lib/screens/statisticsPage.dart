import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myquitbuddy/utils/shared_preferences_service.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  Map<String, int> _cigaretteCounts = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    String? lastDate = await SharedPreferencesService.getLastDate();
    String today = DateTime.now().toIso8601String().substring(0, 10);

    if (lastDate != today) {
      await SharedPreferencesService.resetCounts();
      await SharedPreferencesService.setLastDate(today);
    }

    Map<String, int> counts = await SharedPreferencesService.getCigaretteCounts();
    setState(() {
      _cigaretteCounts = counts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cigarettes Smoked Throughout the Day',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 16.0),
              SizedBox(
                height: 200.0,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: _getBarGroups(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            return Text(value.toInt().toString());
                          },
                          reservedSize: 30,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    return List.generate(24, (index) {
      String hourKey = index.toString().padLeft(2, '0');
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: (_cigaretteCounts[hourKey] ?? 0).toDouble(),
            color: Colors.blue,
          ),
        ],
      );
    });
  }
}