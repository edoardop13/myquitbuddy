import 'package:intl/intl.dart';

class Heartrate {
  final DateTime time;
  final int value;

  const Heartrate({required this.time, required this.value});

  factory Heartrate.fromJson(String date, Map<String, dynamic> json) {
    return Heartrate(
        time: DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
        value: json["value"]);
  }

  @override
  String toString() {
    return 'Heartrate(time: $time, value: $value)';
  }
}
