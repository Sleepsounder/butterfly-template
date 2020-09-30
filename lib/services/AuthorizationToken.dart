import 'dart:convert';
import 'dart:core';

class AuthorizationToken {
  final String accessToken;
  final String refreshToken;
  final DateTime accessTokenExpirationDateTime;
  final String idToken;

  AuthorizationToken(
    this.accessToken,
    this.refreshToken,
    this.accessTokenExpirationDateTime,
    this.idToken,
  );

  AuthorizationToken.fromJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'],
        refreshToken = json['refreshToken'],
        accessTokenExpirationDateTime =
            DateTime.parse(json['accessTokenExpirationDateTime']),
        idToken = json['idToken'];

  AuthorizationToken.fromJson2(Map<String, dynamic> json)
      : accessToken = json['access_token'],
        refreshToken = json['refresh_token'],
        accessTokenExpirationDateTime =
            DateTime.now(),
        idToken = json['id_token'];

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'accessTokenExpirationDateTime':
            accessTokenExpirationDateTime.toIso8601String(),
        'idToken': idToken
      };
  fromRedirectUrl(String redirectUrl) {
    var uri = Uri.parse(redirectUrl);
    {
      uri.queryParameters.forEach((k, v) {
        print('key: $k - value: $v');
      });
    }
  }

  @override
  String toString() => jsonEncode(this);
}
