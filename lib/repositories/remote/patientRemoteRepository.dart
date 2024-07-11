import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart'; // Add this line to import the 'dio' package
import 'package:myquitbuddy/managers/tokenManager.dart';
import 'package:myquitbuddy/models/distance.dart';
import 'package:myquitbuddy/models/heartrate.dart';
import 'package:myquitbuddy/models/patient.dart';
import 'package:myquitbuddy/models/steps.dart';
import 'package:myquitbuddy/utils/appInterceptor.dart';

class PatientRemoteRepository {
  static const _patientsEndpoint = 'study/v1/patients/';

  static final _client = AppInterceptor().dio;

  static Future<List<Patient>?> getPatients() {
    return _client.get(_patientsEndpoint).then((value) async {
      if (value.statusCode != HttpStatus.ok) {
        return null;
      }
      final data = value.data['data'];
      return data
          .cast<Map<String, dynamic>>()
          .map<Patient>((json) => Patient.fromJson(json))
          .toList();
    });
  }

  static Future<int?> getSteps(DateTime date) async {
    var newFormat = DateFormat('y-MM-dd');
    final dateFormatted = newFormat.format(date);
    final patientUsername = await TokenManager.getUsername();

    return _client
        .get('data/v1/steps/patients/$patientUsername/day/$dateFormatted/')
        .then((value) {
      if (value.statusCode != HttpStatus.ok) {
        return null;
      }
      try {
        final data = value.data['data']['data'];
        List<Steps> steps = data
            .cast<Map<String, dynamic>>()
            .map<Steps>((json) => Steps.fromJson(dateFormatted, json))
            .toList();
        return steps.map((e) => e.value).reduce((a, b) => a + b);
      } catch (e) {
        return 0;
      }
    });
  }

  static Future<List<Distance>?> getDistance(DateTime date) async {
    var newFormat = DateFormat('y-MM-dd');
    final dateFormatted = newFormat.format(date);
    final patientUsername = await TokenManager.getUsername();

    return _client
        .get('data/v1/distance/patients/$patientUsername/day/$dateFormatted/')
        .then((value) {
      if (value.statusCode != HttpStatus.ok) {
        return null;
      }
      final data = value.data['data']['data'];
      return data
          .cast<Map<String, dynamic>>()
          .map<Distance>((json) => Distance.fromJson(dateFormatted, json))
          .toList();
    });
  }

  static Future<List<Map<String, dynamic>>?> getHeartRateAverages(DateTime startDate, DateTime endDate) async {
    var newFormat = DateFormat('y-MM-dd');
    final startDateFormatted = newFormat.format(startDate);
    final endDateFormatted = newFormat.format(endDate);
    final patientUsername = await TokenManager.getUsername();

    final url = 'data/v1/heart_rate/patients/$patientUsername/daterange/start_date/$startDateFormatted/end_date/$endDateFormatted';

    try {
      final response = await _client.get(url);

      if (response.statusCode != HttpStatus.ok) {
        print("Error: HTTP ${response.statusCode}");
        return null;
      }

      // Print the raw response data for debugging
      print("Raw response data: ${response.data}");

      // Check if response.data is a Map
      if (response.data is! Map<String, dynamic>) {
        print("Error: Expected a Map, but got ${response.data.runtimeType}");
        return null;
      }

      // Parse the data
      Map<String, dynamic> responseMap = response.data;
      if (responseMap.containsKey('data') && responseMap['data'] is List) {
        List<dynamic> dataList = responseMap['data'];
        
        // Group the data by date
        Map<String, List<HeartRateRecord>> groupedByDate = {};
        for (var item in dataList) {
          if (item is Map<String, dynamic>) {
            String? date = item['date'] as String?;
            if (date != null) {
              if (!groupedByDate.containsKey(date)) {
                groupedByDate[date] = [];
              }
              groupedByDate[date]!.add(HeartRateRecord.fromJson(item));
            }
          }
        }

        // Calculate average for each date
        List<Map<String, dynamic>> averages = [];
        groupedByDate.forEach((date, records) {
          if (records.isNotEmpty) {
            List<int> validValues = records
                .map((r) => r.value)
                .whereType<int>()
                .toList();
            if (validValues.isNotEmpty) {
              double average = validValues.reduce((a, b) => a + b) / validValues.length;
              averages.add({
                'date': date,
                'average_heart_rate': average,
                'record_count': validValues.length
              });
            }
          }
        });

        return averages;
      } else {
        print("Error: 'data' key not found or not a List");
        return null;
      }
    } catch (error) {
      print("Error fetching heart rate data: $error");
      if (error is DioException) {
        print("DioError details: ${error.message}");
        print("DioError type: ${error.type}");
        print("DioError stackTrace: ${error.stackTrace}");
      }
      return null;
    }
  }
}
