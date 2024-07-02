import 'package:intl/intl.dart';

class Steps {
  final DateTime time;
  final int value;

  const Steps({required this.time, required this.value});

  factory Steps.fromJson(String date, Map<String, dynamic> json) {
    return Steps(
        time: DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
        value: int.parse(json["value"]));
  }

  @override
  String toString() {
    return 'Steps(time: $time, value: $value)';
  }
}