import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
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
