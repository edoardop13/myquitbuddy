import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:myquitbuddy/managers/tokenManager.dart';
import 'package:myquitbuddy/utils/appInterceptor.dart';

class AuthRemoteRepository {
  static const _tokenEndpoint = 'gate/v1/token/';

  static Future<bool> login(String username, String password) async {
    final body = {'username': username, 'password': password};
    const url = AppInterceptor.baseUrl + _tokenEndpoint;
    final response = await http.post(Uri.parse(url), body: body);
    if (response.statusCode == HttpStatus.ok) {
      final decodedResponse = jsonDecode(response.body);
      await TokenManager.saveTokens(decodedResponse);
      return true;
    }
    return false;
  }
}