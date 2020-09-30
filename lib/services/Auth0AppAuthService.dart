import 'dart:convert';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:injectable/injectable.dart';
import '../utils/Result.dart';
import 'AuthorizationToken.dart';
import 'exceptions/Auth0Error.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as CustomTabs;
import 'package:http/http.dart' as Http;

@lazySingleton
class Auth0AppAuthService {
  final FlutterAppAuth _appAuth = FlutterAppAuth();
  final String _auth0BaseUrl = GlobalConfiguration().get("auth0BaseUrl");
  final String _auth0ClientId = GlobalConfiguration().get("auth0CLientId");
  final String _auth0RedirectUri = GlobalConfiguration().get("auth0RedirectUri");
  final String _auth0Audience = GlobalConfiguration().get("auth0Audience");
  
  Future<Result<AuthorizationToken, Auth0Error>> login() async {
    try {
      final AuthorizationTokenResponse result =
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(_auth0ClientId, _auth0RedirectUri,
            issuer: "$_auth0BaseUrl",
            scopes: ['openid', 'profile', 'offline_access'],
            promptValues: ['login'],
            preferEphemeralSession: true,
            additionalParameters: {"audience": _auth0Audience}),
      );
      return Result.success(AuthorizationToken(
          result.accessToken,
          result.refreshToken,
          result.accessTokenExpirationDateTime,
          result.idToken));
    } catch (e) {
      return Result.failure(Auth0Error(e.message, null));
    }
  }

  Future<Result<AuthorizationToken, Auth0Error>> signup() async {
    try {
      final AuthorizationTokenResponse result =
        await _appAuth.authorizeAndExchangeCode(
          AuthorizationTokenRequest(
            _auth0ClientId, 
            _auth0RedirectUri,
            issuer: "$_auth0BaseUrl",
            scopes: ['openid', 'profile', 'offline_access'],
            promptValues: ['login'],
            additionalParameters: {
              "audience": _auth0Audience,
              "screen_hint": "signup"
            }
          ),
        );
      return Result.success(AuthorizationToken(
        result.accessToken,
        result.refreshToken,
        result.accessTokenExpirationDateTime,
        result.idToken));
    } catch (e) {
      return Result.failure(Auth0Error(e.message, null));
    }
  }

  Future<Result<String, Auth0Error>> logout(String accessToken) async {
    try {
      final url = '$_auth0BaseUrl/v2/logout?federated';
      await _launchURL(url);
      return Result.success("Ok");
    } catch (e) {
      return Result.failure(Auth0Error(e.message, null));
    }
  }

  Future<Map> getUserDetails(String accessToken) async {
    final url = '$_auth0BaseUrl/userinfo';
    final response = await Http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<void> _launchURL(String url) async {
    try {
      await CustomTabs.launch(
        url,
        option: new CustomTabs.CustomTabsOption(
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: new CustomTabs.CustomTabsAnimation.slideIn(),
          extraCustomTabs: <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
    }
  }
}