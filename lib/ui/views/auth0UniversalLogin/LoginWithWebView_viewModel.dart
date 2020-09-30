import 'package:butterfly/services/Auth0Service.dart';
import 'package:butterfly/services/SecureStorageService.dart';
import 'package:butterfly/services/UserInfoService.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../app/locator.dart';

class LoginWithWebViewViewModel extends BaseViewModel {
  final _auth0Service = locator<Auth0Service>();
  final _secureStorageService = locator<SecureStorageService>();
  final _userInfoService = locator<UserInfoService>();
  String _logInError = "";
  String get logInError => _logInError;
  String _signUpError = "";
  String get signUpError => _signUpError;
  String _logOutError = "";
  String get logOutError => _logOutError;
  bool _showUniversalLogin = false;
  bool get showUniversalLogin => _showUniversalLogin;
  String _url;
  String get url => _url;
  String _codeVerifier;
  String _codeChallenge;

  Future<void> loginAction() async {
    _generateCodeChallengeAndVerifier();
    _url = _auth0Service.getLoginUrl(_codeChallenge);
    _showUniversalLogin = true;
    notifyListeners();
  }

  Future<void> signUpAction() async {
    try {
      _signUpError = "";
      _generateCodeChallengeAndVerifier();
      _url = _auth0Service.getSignUpUrl(_codeChallenge);
      _showUniversalLogin = true;
    notifyListeners();
    } catch (e) {
      _signUpError = e.message;
      notifyListeners();
    }
  }

  Future<void> logOutAction() async {
    // try {
    //   var token = await _secureStorageService.readToken();
    //   _auth0Service.getLogoutUrl()
    //   if (result.isSuccess) {
    //     _secureStorageService.removeToken();
    //     _userInfoService.updateName("");
    //   } else {
    //     _logOutError = result.error.message;
    //     notifyListeners();
    //   }
    // } catch (e) {
    //   _logOutError = e.message;
    //   notifyListeners();
    // }
    _url = _auth0Service.getLogoutUrl();
    _showUniversalLogin = true;
    notifyListeners();
  }

  void onPageFinished(String url){
    if (url == _auth0Service.getLogoutUrl()){
      _showUniversalLogin = false;
      _userInfoService.updateName("");
      _secureStorageService.removeToken();
      notifyListeners();
    }
  }

  Future<NavigationDecision> onNavigation(NavigationRequest request) async {
    var result = await _auth0Service.handleRedirectionAndGetToken(
        request.url, _codeVerifier);
    if (result.isSuccess) {
      if (result.value.redirectedBackToApp) {
        _showUniversalLogin = false;
        _secureStorageService.writeToken(result.value.authorizationToken);
        var user = await _auth0Service.getUserDetails(result.value.authorizationToken.accessToken);
        _userInfoService.updateName(user['nickname']);
        notifyListeners();
        return NavigationDecision.prevent;
      } else {
        return NavigationDecision.navigate;
      }
    } else {
      _logInError = result.error.message;
      _showUniversalLogin = false;
      notifyListeners();
      return NavigationDecision.prevent;
    }
  }

  void _generateCodeChallengeAndVerifier(){
    _codeVerifier = _auth0Service.generateCodeVerifier();
    _codeChallenge = _auth0Service.generateCodeChallenge(_codeVerifier);
  }
}
