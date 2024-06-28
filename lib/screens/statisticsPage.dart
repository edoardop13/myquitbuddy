import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPage createState() => _StatisticsPage();
}

class _StatisticsPage extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: BarChart(
        BarChartData(
            // read about it in the LineChartData section
            ),
      ),
    ));
  } //build
}
