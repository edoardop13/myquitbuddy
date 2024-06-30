import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:myquitbuddy/models/patient.dart';

class TokenManager {
  static const _accessToken = 'access_token';
  static const _refreshToken = 'refresh_token';
  static const _username = 'username';

  static const _storage = FlutterSecureStorage();

  static Future<String?> getAccessToken() => _storage.read(key: _accessToken);

  static Future<String?> getRefreshToken() => _storage.read(key: _refreshToken);

  static Future<void> saveTokens(Map<String, dynamic> json) async {
    //print("Token refreshed");
    await _storage.write(key: _accessToken, value: json['access']);
    await _storage.write(key: _refreshToken, value: json['refresh']);
  }

  static Future<void> clearTokens() async {
    await _storage.delete(key: _accessToken);
    await _storage.delete(key: _refreshToken);
  }

  static Future<bool> isAccessTokenExpired() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) {
      return true;
    }
    final isExpired = JwtDecoder.isExpired(accessToken);
    /*if (!isExpired) {
      final seconds = JwtDecoder.getRemainingTime(accessToken).inSeconds;
      print("The access token is still valid for $seconds seconds");
    }*/
    return isExpired;
  }

  static Future<bool> isRefreshTokenExpired() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      return true;
    }
    final isExpired = JwtDecoder.isExpired(refreshToken);
    /*if (!isExpired) {
      final seconds = JwtDecoder.getRemainingTime(refreshToken).inSeconds;
      print("The refresh token is still valid for $seconds seconds");
    }*/
    return isExpired;
  }

  static Future<void> saveUsername(Patient patient) async {
    await _storage.write(key: _username, value: patient.username);
  }

  static Future<String?> getUsername() => _storage.read(key: _username);
}