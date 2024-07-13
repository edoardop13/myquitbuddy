import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myquitbuddy/repositories/remote/patientRemoteRepository.dart';
import 'package:myquitbuddy/sharedWidgets/graph_info_popup.dart';
import 'package:myquitbuddy/utils/sqlite_service.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

enum InfoPopupType { smokedToday, heatmap, heartrate, distance, calories, sleep }

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
              _buildGraphCard(
                context,
                title: 'Today\'s Cigarettes',
                child: Column(
                  children: [
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
                  ],
                ), type: InfoPopupType.smokedToday,
              ),
              const SizedBox(height: 16.0),
              _buildGraphCard(
                context,
                title: 'Smoking Heatmap',
                child: Column(
                  children: [
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
                ), type: InfoPopupType.heatmap,
              ),
              const SizedBox(height: 16.0),
              _buildGraphCard(
                context,
                title: "Heartrate",
                child: FutureBuilder<Widget>(
                  future: _buildHeartrateChart(),
                  builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return snapshot.data ?? Container();
                    }
                  },
                ), type: InfoPopupType.heartrate,
              ),
              const SizedBox(height: 16.0),
              _buildGraphCard(
                context,
                title: "Distance",
                child: FutureBuilder<Widget>(
                  future: _buildDistanceChart(),
                  builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return snapshot.data ?? Container();
                    }
                  },
                ), type: InfoPopupType.distance,
              ),
              const SizedBox(height: 16.0),
              _buildGraphCard(
                context,
                title: "Calories",
                child: FutureBuilder<Widget>(
                  future: _buildCaloriesChart(),
                  builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return snapshot.data ?? Container();
                    }
                  },
                ), type: InfoPopupType.calories,
              ),
              const SizedBox(height: 16.0),
              _buildGraphCard(
                context,
                title: "Sleep",
                child: FutureBuilder<Widget>(
                  future: _buildSleepChart(),
                  builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return snapshot.data ?? Container();
                    }
                  },
                ), type: InfoPopupType.sleep,
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
            color: Colors.orange,
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

  Widget _buildGraphCard(BuildContext context, {required String title, required InfoPopupType type, required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      shadowColor: Theme.of(context).brightness == Brightness.dark ? Colors.transparent : Colors.grey.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(width: 2.0),
                  IconButton(
                    icon: Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
                    onPressed: () => _showInfoDialog(context, type),
                  ),
              ]
            ),
            const SizedBox(height: 16.0),
            child,
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context, InfoPopupType type) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => new GraphInfoPopup(type),
    );
  }

  // Placeholder for a line chart for heart rate
  Future<Widget> _buildHeartrateChart() async {
    final endDate = DateTime.now().subtract(const Duration(days: 1));
    final startDate = endDate.subtract(const Duration(days: 7));
    final measures = await PatientRemoteRepository.getHeartRateAverages(startDate, endDate);

    return SizedBox(
      height: 400,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
              axisNameWidget: Text(
                'Average heartbeat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              axisNameSize: 30,
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 1:
                      return Text(DateTime.parse(measures?.elementAt(1)['date']).day.toString());
                    case 2:
                      return Text(DateTime.parse(measures?.elementAt(2)['date']).day.toString());
                    case 3:
                      return Text(DateTime.parse(measures?.elementAt(3)['date']).day.toString());
                    case 4:
                      return Text(DateTime.parse(measures?.elementAt(4)['date']).day.toString());
                    case 5:
                      return Text(DateTime.parse(measures?.elementAt(5)['date']).day.toString());
                    case 6:
                      return Text(DateTime.parse(measures?.elementAt(6)['date']).day.toString());
                    case 7:
                      return Text(DateTime.parse(measures?.elementAt(7)['date']).day.toString());
                    default:
                      return const Text('');
                    }
                },
              ),
              axisNameWidget: const Text(
                'Day of the month',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              axisNameSize: 30,
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(1, measures?.elementAt(0)['average_heart_rate']),
                FlSpot(2, measures?.elementAt(1)['average_heart_rate']),
                FlSpot(3, measures?.elementAt(2)['average_heart_rate']),
                FlSpot(4, measures?.elementAt(3)['average_heart_rate']),
                FlSpot(5, measures?.elementAt(4)['average_heart_rate']),
                FlSpot(6, measures?.elementAt(5)['average_heart_rate']),
                FlSpot(7, measures?.elementAt(6)['average_heart_rate']),
                //for (int i = 0; i < 7; i++)
                //  FlSpot(
                //    double.parse(measures?.elementAt(i)['date'].split('-')[2]),
                //    measures?.elementAt(i)['average_heart_rate'],
                //  ),
              ],
              isCurved: true,
              color: Colors.red,
              barWidth: 4,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.red.withOpacity(0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Widget> _buildDistanceChart() async {
    final endDate = DateTime.now().subtract(const Duration(days: 1));
    final startDate = endDate.subtract(const Duration(days: 7));
    final measures = await PatientRemoteRepository.getDailyDistanceTotal(startDate, endDate);

    return SizedBox(
      height: 400,
      child: BarChart(
        BarChartData(
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
              axisNameWidget: Text(
                'Total distance (KM)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              axisNameSize: 30,
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 42,
              ),
              axisNameWidget: Text(
                'Day of the month',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              axisNameSize: 30,
            ),
          ),
          barGroups: [
            for (int i = 1; i < 8; i++)
              BarChartGroupData(
                x: int.parse(measures?.elementAt(i)['date'].split('-')[2]),
                barRods: [
                  BarChartRodData(toY: measures?.elementAt(i)['total_distance']/100000, color: Colors.greenAccent),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<Widget> _buildCaloriesChart() async {
    final endDate = DateTime.now().subtract(const Duration(days: 1));
    final startDate = endDate.subtract(const Duration(days: 7));
    final measures = await PatientRemoteRepository.getDailyCaloriesTotal(startDate, endDate);

    return SizedBox(
      height: 400,
      child: BarChart(
        BarChartData(
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
              axisNameWidget: Text(
                'Total calories',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              axisNameSize: 30,
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 42,
              ),
              axisNameWidget: Text(
                'Day of the month',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              axisNameSize: 30,
            ),
          ),
          barGroups: [
            for (int i = 1; i < 8; i++)
              BarChartGroupData(
                x: int.parse(measures?.elementAt(i)['date'].split('-')[2]),
                barRods: [
                  BarChartRodData(toY: measures?.elementAt(i)['total_calories'], color: Colors.orange),
                ],
              ),
          ],
        ),
      ),
    );
  }


  Future<Widget> _buildSleepChart() async {
    final endDate = DateTime.now().subtract(const Duration(days: 1));
    final startDate = endDate.subtract(const Duration(days: 7));
    final measures = await PatientRemoteRepository.getDailySleepTotal(startDate, endDate);

    return SizedBox(
      height: 350,
      child: BarChart(
        BarChartData(
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
              axisNameWidget: Text(
                'Total sleep (hours)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              axisNameSize: 30,
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 42,
              ),
              axisNameWidget: Text(
                'Day of the month',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              axisNameSize: 30,
            ),
          ),
          barGroups: [
            for (int i = 1; i < 8; i++)
              BarChartGroupData(
                x: int.parse(measures?.elementAt(i)['date'].split('-')[2]),
                barRods: [
                  BarChartRodData(toY: measures?.elementAt(i)['total_sleep']/60, color: Colors.lightBlueAccent),
                ],
              ),
          ],
        ),
      ),
    );
  }
}