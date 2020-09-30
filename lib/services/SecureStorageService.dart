import 'dart:convert';

import 'package:butterfly/services/AuthorizationToken.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

const String _TOKEN_KEY = "Token";

@lazySingleton
class SecureStorageService{
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> write(String key, String value) async {
    if (key == null || key.isEmpty) throw ArgumentError.notNull("key");
    if (value == null || value.isEmpty) throw ArgumentError.notNull("value");
    await _secureStorage.write(key: key, value: value);
  }

  Future<String> read(String key) async {
    if (key == null || key.isEmpty) throw ArgumentError.notNull("key");
    return _secureStorage.read(key: key);
  }

  Future<void> writeToken(AuthorizationToken token) async {
    var value = token.toString();
    if (value == null || value.isEmpty) throw ArgumentError.notNull("value");
    await _secureStorage.write(key: _TOKEN_KEY, value: value);
  }

  Future<AuthorizationToken> readToken() async {
    var token = await _secureStorage.read(key: _TOKEN_KEY);
    return AuthorizationToken.fromJson(jsonDecode(token));
  }

  Future<void> removeToken() async {
    await _secureStorage.delete(key: _TOKEN_KEY);
  }
}