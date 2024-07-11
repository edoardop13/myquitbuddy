import 'package:intl/intl.dart';

class DailyHeartRate {
  final String date;
  final List<HeartRateRecord> data;

  DailyHeartRate({required this.date, required this.data});

  factory DailyHeartRate.fromJson(Map<String, dynamic> json) {
    return DailyHeartRate(
      date: json['date'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => HeartRateRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class HeartRateRecord {
  final String? time;
  final int? value;
  final int? confidence;

  HeartRateRecord({this.time, this.value, this.confidence});

  factory HeartRateRecord.fromJson(Map<String, dynamic> json) {
    return HeartRateRecord(
      time: json['time'] as String?,
      value: json['value'] as int?,
      confidence: json['confidence'] as int?,
    );
  }
}