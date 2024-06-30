import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:myquitbuddy/managers/tokenManager.dart';
import 'package:myquitbuddy/models/patient.dart';
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
}