import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HealthStatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Stats'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildGraphCard(
              context,
              title: "Heart Rate",
              child: _buildLineChart(), // Implement a method to build line chart for heart rate
            ),
            const SizedBox(height: 16.0),
            _buildGraphCard(
              context,
              title: "Distance",
              child: _buildBarChart(), // Implement a method to build bar chart for distance
            ),
            const SizedBox(height: 16.0),
            _buildGraphCard(
              context,
              title: "Calories",
              child: _buildPieChart(), // Implement a method to build pie chart for calories
            ),
            const SizedBox(height: 16.0),
            _buildGraphCard(
              context,
              title: "Sleep",
              child: _buildLineChart(), // Implement a method to build line chart for sleep
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphCard(BuildContext context, {required String title, required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16.0),
            child,
          ],
        ),
      ),
    );
  }

  // Placeholder for a line chart for heart rate
  Widget _buildLineChart() {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 70),
                FlSpot(1, 80),
                FlSpot(2, 75),
                FlSpot(3, 90),
                FlSpot(4, 85),
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

  // Placeholder for a bar chart for distance
  Widget _buildBarChart() {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(toY: 5, color: Colors.blue),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(toY: 6, color: Colors.blue),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(toY: 5.5, color: Colors.blue),
              ],
            ),
            BarChartGroupData(
              x: 3,
              barRods: [
                BarChartRodData(toY: 7, color: Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Placeholder for a pie chart for calories
  Widget _buildPieChart() {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: 40,
              title: '40%',
              color: Colors.orange,
            ),
            PieChartSectionData(
              value: 30,
              title: '30%',
              color: Colors.yellow,
            ),
            PieChartSectionData(
              value: 20,
              title: '20%',
              color: Colors.green,
            ),
            PieChartSectionData(
              value: 10,
              title: '10%',
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
