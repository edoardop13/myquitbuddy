import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:myquitbuddy/managers/tokenManager.dart';
import 'package:myquitbuddy/models/distance.dart';
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
}