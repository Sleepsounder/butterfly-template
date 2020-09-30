import 'dart:convert';
import 'dart:math';
import 'package:butterfly/services/Auth0RedirectionResponse.dart';
import 'package:butterfly/services/AuthorizationToken.dart';
import 'package:butterfly/utils/Result.dart';
import 'package:crypto/crypto.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

import 'exceptions/Auth0Error.dart';


@lazySingleton
class Auth0Service {
  final String _auth0BaseUrl = GlobalConfiguration().get("auth0BaseUrl");
  final String _auth0ClientId = GlobalConfiguration().get("auth0CLientId");
  final String _auth0RedirectUri =
      GlobalConfiguration().get("auth0RedirectUri");
  final String _auth0Audience = GlobalConfiguration().get("auth0Audience");

  Map<String, dynamic> parseIdToken(String idToken) {
    final parts = idToken.split(r'.');
    assert(parts.length == 3);
    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  Future<Map> getUserDetails(String accessToken) async {
    final url = '$_auth0BaseUrl/userinfo';
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  String getLoginUrl(String codeChallenge) {
    String url =
        "$_auth0BaseUrl/authorize?response_type=code&client_id=$_auth0ClientId&redirect_uri=$_auth0RedirectUri&scope=openid%20profile%20offline_access&audience=$_auth0Audience&code_challenge_method=S256&code_challenge=$codeChallenge&prompt=login";
    return url;
  }

  String getSignUpUrl(String codeChallenge) {
    String url =
        "$_auth0BaseUrl/authorize?response_type=code&client_id=$_auth0ClientId&redirect_uri=$_auth0RedirectUri&scope=openid%20profile%20offline_access&audience=$_auth0Audience&code_challenge_method=S256&code_challenge=$codeChallenge&prompt=login&screen_hint=signup";
    return url;
  }

  String getLogoutUrl() {
    String url = "$_auth0BaseUrl/v2/logout?federated";
    return url;
  }

  Future<Result<Auth0RediredctionResponse, Auth0Error>>
      handleRedirectionAndGetToken(
          String redirectUrl, String codeVerifier) async {
    if (redirectUrl.startsWith(_auth0RedirectUri)) {
      var result = getCodeFromUrl(redirectUrl);
      if (result.isSuccess) {
        String code = result.value;
        var response = await http.post(
          "$_auth0BaseUrl/oauth/token",
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8",
          },
          body: jsonEncode(<String, String>{
            "grant_type": "authorization_code",
            "client_id": _auth0ClientId,
            "code_verifier": codeVerifier,
            "code": code,
            "redirect_uri": _auth0RedirectUri
          }),
        );
        if (response.statusCode == 200) {
          var t = json.decode(response.body);
          return Result.success(Auth0RediredctionResponse(
              true, AuthorizationToken.fromJson2(json.decode(response.body))));
        } else {
          return Result.failure(Auth0Error(response.reasonPhrase, 500));
        }
      } else {
        return Result.failure(result.error);
      }
    } else {
      return Result.success(Auth0RediredctionResponse(false, null));
    }
  }

  Result<String, Auth0Error> getCodeFromUrl(url) {
    var uri = Uri.parse(url);
    if (uri.queryParameters.containsKey("code")) {
      return Result.success(uri.queryParameters["code"]);
    }
    var error = uri.queryParameters.containsKey("error")
        ? uri.queryParameters["error"]
        : "Internal error";
    var errorMessage = uri.queryParameters.containsKey("error_description")
        ? uri.queryParameters["error_description"]
        : "";
    return Result.failure(Auth0Error("$error: $errorMessage", 500));
  }

  fromRedirectUrl(String redirectUrl) {
    var uri = Uri.parse(redirectUrl);
    {
      uri.queryParameters.forEach((k, v) {
        print('key: $k - value: $v');
      });
    }
  }

  String generateCryptoRandomString([int length = 32]) {
    Random random = Random.secure();
    var values = List<int>.generate(length, (i) => random.nextInt(256));

    return base64Url.encode(values);
  }

  String generateCodeVerifier() {
    return generateCryptoRandomString()
        .replaceAll("=", "")
        .replaceAll("+", "-")
        .replaceAll("/", "_");
  }

  String generateCodeChallenge(String codeVerifier) {
    return base64UrlEncode(sha256.convert(utf8.encode(codeVerifier)).bytes)
        .replaceAll("=", "")
        .replaceAll("+", "-")
        .replaceAll("/", "_");
  }
}
