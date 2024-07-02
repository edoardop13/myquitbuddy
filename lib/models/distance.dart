import 'package:intl/intl.dart';

class Distance {
  final DateTime time;
  final double value;

  const Distance({required this.time, required this.value});

  factory Distance.fromJson(String date, Map<String, dynamic> json) {
    return Distance(
        time: DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
        value: double.parse(json["value"]) / 100);
  }

  @override
  String toString() {
    return 'Distance(time: $time, value: $value)';
  }
}