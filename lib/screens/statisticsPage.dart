import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myquitbuddy/utils/sqlite_service.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  Map<String, int> _cigaretteCounts = {};
  Map<DateTime, int> _heatmapData = {};
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      String today = DateTime.now().toIso8601String().substring(0, 10);
      Map<String, int> counts = await SQLiteService.getCigaretteCounts(today);
      Map<DateTime, int> heatmapData = await SQLiteService.getWeeklyData();

      setState(() {
        _cigaretteCounts = counts;
        _heatmapData = heatmapData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading data: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Statistics',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cigarettes Smoked Today',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                height: 300.0,
                child: _cigaretteCounts.isEmpty
                    ? const Center(child: Text('No data for today'))
                    : BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: _getMaxY(),
                    barGroups: _getBarGroups(),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            );
                          },
                          reservedSize: 30,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey),
                    ),
                    gridData: const FlGridData(show: false),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Total cigarettes today: ${_cigaretteCounts.values.fold(0, (sum, count) => sum + count)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 32.0),
              Text(
                'Smoking Heatmap',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16.0),
              Center(
                child: _heatmapData.isEmpty
                    ? const Text('No data for heatmap')
                    : HeatMap(
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
                    1: Colors.red[50]!,
                    3: Colors.red[200]!,
                    5: Colors.red[400]!,
                    7: Colors.red[600]!,
                    9: Colors.red[800]!,
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: Text(
                  'Color intensity indicates the number of cigarettes smoked.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
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
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    });
  }

  double _getMaxY() {
    if (_cigaretteCounts.isEmpty) return 5;
    return _cigaretteCounts.values.reduce((max, value) => max > value ? max : value).toDouble() + 1;
  }
}