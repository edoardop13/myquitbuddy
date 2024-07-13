import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
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
        // Print the raw response data for debugging
        print("Raw response data: ${value.data}");
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

  static Future<int?> getDayTotalDistance(DateTime date) async {
    var newFormat = DateFormat('y-MM-dd');
    final dateFormatted = newFormat.format(date);
    final patientUsername = await TokenManager.getUsername();

    try {
      final response = await _client.get('data/v1/distance/patients/$patientUsername/day/$dateFormatted/');

      if (response.statusCode != HttpStatus.ok) {
        print("Error: HTTP ${response.statusCode}");
        return null;
      }

      // Check if response.data is a Map
      if (response.data is! Map<String, dynamic>) {
        print("Error: Expected a Map, but got ${response.data.runtimeType}");
        return null;
      }

      Map<String, dynamic> responseMap = response.data;
      List<dynamic> dataList = responseMap['data']['data'];
      List<Map<String, dynamic>> average = [];
          
      int totalDistance = 0;
      for (var item in dataList) {
        int? value = int.parse(item['value']);
        if (value != null) {
          totalDistance += value;
        }
      }

      return totalDistance;
    } catch (error) {
      print("Error fetching data: $error");
      if (error is DioException) {
        print("DioError details: ${error.message}");
        print("DioError type: ${error.type}");
        print("DioError stackTrace: ${error.stackTrace}");
      }
      return null;
    }
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

      // Check if response.data is a Map
      if (response.data is! Map<String, dynamic>) {
        print("Error: Expected a Map, but got ${response.data.runtimeType}");
        return null;
      }

      Map<String, dynamic> responseMap = response.data;
      List<dynamic> dataList = responseMap['data'];
      List<Map<String, dynamic>> averages = [];

      for (var dateData in dataList) {
        if (dateData is Map<String, dynamic> && 
            dateData.containsKey('date') && 
            dateData.containsKey('data')) {
          String date = dateData['date'];
          List<dynamic> heartRateData = dateData['data'];
          
          List<int> validValues = [];
          for (var item in heartRateData) {
            if (item is Map<String, dynamic> && item.containsKey('value')) {
              int? value = item['value'];
              if (value != null) {
                validValues.add(value);
              }
            }
          }

          if (validValues.isNotEmpty) {
            double average = validValues.reduce((a, b) => a + b) / validValues.length;
            averages.add({
              'date': date,
              'average_heart_rate': average,
              'record_count': validValues.length
            });
          }
        }
      }

      return averages;
    } catch (error) {
      print("Error fetching data: $error");
      if (error is DioException) {
        print("DioError details: ${error.message}");
        print("DioError type: ${error.type}");
        print("DioError stackTrace: ${error.stackTrace}");
      }
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> getDailyDistanceTotal(DateTime startDate, DateTime endDate) async {
    var newFormat = DateFormat('y-MM-dd');
    final startDateFormatted = newFormat.format(startDate);
    final endDateFormatted = newFormat.format(endDate);
    final patientUsername = await TokenManager.getUsername();

    final url = 'data/v1/distance/patients/$patientUsername/daterange/start_date/$startDateFormatted/end_date/$endDateFormatted';

    try {
      final response = await _client.get(url);

      if (response.statusCode != HttpStatus.ok) {
        print("Error: HTTP ${response.statusCode}");
        return null;
      }

      // Check if response.data is a Map
      if (response.data is! Map<String, dynamic>) {
        print("Error: Expected a Map, but got ${response.data.runtimeType}");
        return null;
      }

      Map<String, dynamic> responseMap = response.data;
      List<dynamic> dataList = responseMap['data'];
      List<Map<String, dynamic>> averages = [];

      for (var dateData in dataList) {
        if (dateData is Map<String, dynamic> &&
            dateData.containsKey('date') &&
            dateData.containsKey('data')) {
          String date = dateData['date'];
          List<dynamic> distanceData = dateData['data'];

          List<double> validValues = [];
          for (var item in distanceData) {
            if (item is Map<String, dynamic> && item.containsKey('value')) {
              double? value = double.parse(item['value']);
              if (value != null) {
                validValues.add(value);
              }
            }
          }

          if (validValues.isNotEmpty) {
            double total = validValues.reduce((a, b) => a + b);
            averages.add({
              'date': date,
              'total_distance': total,
              'record_count': validValues.length
            });
          }
        }
      }

      return averages;
    } catch (error) {
      print("Error fetching data: $error");
      if (error is DioException) {
        print("DioError details: ${error.message}");
        print("DioError type: ${error.type}");
        print("DioError stackTrace: ${error.stackTrace}");
      }
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> getDailyCaloriesTotal(DateTime startDate, DateTime endDate) async {
    var newFormat = DateFormat('y-MM-dd');
    final startDateFormatted = newFormat.format(startDate);
    final endDateFormatted = newFormat.format(endDate);
    final patientUsername = await TokenManager.getUsername();

    final url = 'data/v1/calories/patients/$patientUsername/daterange/start_date/$startDateFormatted/end_date/$endDateFormatted';

    try {
      final response = await _client.get(url);

      if (response.statusCode != HttpStatus.ok) {
        print("Error: HTTP ${response.statusCode}");
        return null;
      }

      // Check if response.data is a Map
      if (response.data is! Map<String, dynamic>) {
        print("Error: Expected a Map, but got ${response.data.runtimeType}");
        return null;
      }

      Map<String, dynamic> responseMap = response.data;
      List<dynamic> dataList = responseMap['data'];
      List<Map<String, dynamic>> averages = [];

      for (var dateData in dataList) {
        if (dateData is Map<String, dynamic> &&
            dateData.containsKey('date') &&
            dateData.containsKey('data')) {
          String date = dateData['date'];
          List<dynamic> distanceData = dateData['data'];

          List<double> validValues = [];
          for (var item in distanceData) {
            if (item is Map<String, dynamic> && item.containsKey('value')) {
              double? value = double.parse(item['value']);
              if (value != null) {
                validValues.add(value);
              }
            }
          }

          if (validValues.isNotEmpty) {
            double total = validValues.reduce((a, b) => a + b);
            averages.add({
              'date': date,
              'total_calories': num.parse(total.toStringAsFixed(2)),
              'record_count': validValues.length
            });
          }
        }
      }

      return averages;
    } catch (error) {
      print("Error fetching data: $error");
      if (error is DioException) {
        print("DioError details: ${error.message}");
        print("DioError type: ${error.type}");
        print("DioError stackTrace: ${error.stackTrace}");
      }
      return null;
    }
  }


  static Future<double?> getDayTotalCalories(DateTime date) async {
    var newFormat = DateFormat('y-MM-dd');
    final dateFormatted = newFormat.format(date);
    final patientUsername = await TokenManager.getUsername();

    try {
      final response = await _client.get('data/v1/calories/patients/$patientUsername/day/$dateFormatted/');

      if (response.statusCode != HttpStatus.ok) {
        print("Error: HTTP ${response.statusCode}");
        return null;
      }

      // Check if response.data is a Map
      if (response.data is! Map<String, dynamic>) {
        print("Error: Expected a Map, but got ${response.data.runtimeType}");
        return null;
      }

      Map<String, dynamic> responseMap = response.data;
      List<dynamic> dataList = responseMap['data']['data'];
          
      double total = 0;
      for (var item in dataList) {
        double? value = double.parse(item['value']);
        if (value != null) {
          total += value;
        }
      }

      return total;
    } catch (error) {
      print("Error fetching data: $error");
      if (error is DioException) {
        print("DioError details: ${error.message}");
        print("DioError type: ${error.type}");
        print("DioError stackTrace: ${error.stackTrace}");
      }
      return null;
    }
  }

  static Future<int?> getDayTotalSleep(DateTime date) async {
    var newFormat = DateFormat('y-MM-dd');
    final dateFormatted = newFormat.format(date);
    final patientUsername = await TokenManager.getUsername();

    try {
      final response = await _client.get('data/v1/sleep/patients/$patientUsername/day/$dateFormatted/');

      if (response.statusCode != HttpStatus.ok) {
        print("Error: HTTP ${response.statusCode}");
        return null;
      }

      // Check if response.data is a Map
      if (response.data is! Map<String, dynamic>) {
        print("Error: Expected a Map, but got ${response.data.runtimeType}");
        return null;
      }

      Map<String, dynamic> responseMap = response.data;
      int timeInBed = responseMap['data']['data'][0]['timeInBed'];

      return timeInBed;
    } catch (error) {
      print("Error fetching data: $error");
      if (error is DioException) {
        print("DioError details: ${error.message}");
        print("DioError type: ${error.type}");
        print("DioError stackTrace: ${error.stackTrace}");
      }
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> getDailySleepTotal(DateTime startDate, DateTime endDate) async {
    var newFormat = DateFormat('y-MM-dd');
    final startDateFormatted = newFormat.format(startDate);
    final endDateFormatted = newFormat.format(endDate);
    final patientUsername = await TokenManager.getUsername();

    final url = 'data/v1/sleep/patients/$patientUsername/daterange/start_date/$startDateFormatted/end_date/$endDateFormatted';

    try {
      final response = await _client.get(url);

      if (response.statusCode != HttpStatus.ok) {
        print("Error: HTTP ${response.statusCode}");
        return null;
      }

      // Check if response.data is a Map
      if (response.data is! Map<String, dynamic>) {
        print("Error: Expected a Map, but got ${response.data.runtimeType}");
        return null;
      }

      Map<String, dynamic> responseMap = response.data;
      List<dynamic> dataList = responseMap['data'];
      List<Map<String, dynamic>> averages = [];

      for (var dateData in dataList) {
        if (dateData is Map<String, dynamic> &&
            dateData.containsKey('date') &&
            dateData.containsKey('data')) {
          String date = dateData['date'];
          List<dynamic> sleepData = dateData['data'];
          
          if (!sleepData.isEmpty) {
              averages.add({
              'date': date,
              'total_sleep': sleepData[0]['timeInBed'],
              });
          } else {
            averages.add({
              'date': date,
              'total_sleep': 0,
              });
          }
        }
      }

      return averages;
    } catch (error) {
      print("Error fetching data: $error");
      if (error is DioException) {
        print("DioError details: ${error.message}");
        print("DioError type: ${error.type}");
        print("DioError stackTrace: ${error.stackTrace}");
      }
      return null;
    }
  }
}