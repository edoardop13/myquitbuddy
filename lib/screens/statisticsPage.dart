import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myquitbuddy/utils/shared_preferences_service.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<int> _cigarettesPerHour = List.filled(24, 0);
  int _minHour = 0;
  int _maxHour = 23;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    int totalCigarettes = await SharedPreferencesService.getCigaretteCount();
    // Simulating cigarette counts per hour for demonstration purposes
    // Replace this with your actual data retrieval logic
    setState(() {
      for (int i = 0; i < totalCigarettes; i++) {
        int hour = DateTime.now().hour;
        _cigarettesPerHour[hour] = (_cigarettesPerHour[hour] + 1) % 24;
      }
      _updateHourRange();
    });
  }

  void _updateHourRange() {
    _minHour = _cigarettesPerHour.indexWhere((count) => count > 0);
    _maxHour = _cigarettesPerHour.lastIndexWhere((count) => count > 0);

    // Default range if no cigarettes were smoked today
    if (_minHour == -1) _minHour = 0;
    if (_maxHour == -1) _maxHour = 2; // Show at least the first 3 hours
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
                    barGroups: _cigarettesPerHour
                        .asMap()
                        .entries
                        .where((entry) => entry.key >= _minHour && entry.key <= _maxHour)
                        .map(
                          (entry) => BarChartGroupData(
                            x: entry.key,
                            barRods: [
                              BarChartRodData(
                                toY: entry.value.toDouble(),
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        )
                        .toList(),
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
              SizedBox(height: 32.0),
              Text(
                'Other Statistics',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 16.0),
              // Reuse the previous placeholder for additional statistics
              SizedBox(
                height: 200.0,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: _cigarettesPerHour
                        .asMap()
                        .entries
                        .map(
                          (entry) => BarChartGroupData(
                            x: entry.key,
                            barRods: [
                              BarChartRodData(
                                toY: entry.value.toDouble(),
                                color: Colors.green,
                              ),
                            ],
                          ),
                        )
                        .toList(),
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
}