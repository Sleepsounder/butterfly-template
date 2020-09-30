import 'package:butterfly/services/Auth0AppAuthService.dart';
import 'package:butterfly/services/SecureStorageService.dart';
import 'package:butterfly/services/UserInfoService.dart';
import 'package:stacked/stacked.dart';

import '../../../app/locator.dart';

class LoginWithAppauthViewModel extends BaseViewModel {
  final _auth0Service = locator<Auth0AppAuthService>();
  final _secureStorageService = locator<SecureStorageService>();
  final _userInfoService = locator<UserInfoService>();
  String _logInError = "";
  String get logInError => _logInError;
  String _signUpError = "";
  String get signUpError => _signUpError;
  String _logOutError = "";
  String get logOutError => _logOutError;

  Future<void> loginAction() async {
    try {
      _logInError = "";
      var result = await _auth0Service.login();
      if (result.isSuccess) {
        await _secureStorageService.writeToken(result.value);
        final userInfo = await _auth0Service.getUserDetails(result.value.accessToken);
        _userInfoService.updateName(userInfo['nickname']);
      } else {
        _logInError = result.error.message;
      }
    } on Error catch(e) {
      _logInError = e.toString();
    } catch(e) {
      _logInError = e.message;
    } finally {
      notifyListeners();
    }
  }

  Future<void> signUpAction() async {
    try {
      _signUpError = "";
      var result = await _auth0Service.signup();
      if (result.isSuccess) {
        await _secureStorageService.writeToken(result.value);
        final userInfo = await _auth0Service.getUserDetails(result.value.accessToken);
        _userInfoService.updateName(userInfo['nickname']);
      } else {
        _logInError = result.error.message;
        notifyListeners();
      }
    } catch (e) {
      _signUpError = e.message;
      notifyListeners();
    }
  }

  Future<void> logOutAction() async {
    try {
      var token = await _secureStorageService.readToken();
      var result = await _auth0Service.logout(token.accessToken);
      if (result.isSuccess) {
        _secureStorageService.removeToken();
        _userInfoService.updateName("");
      } else {
        _logOutError = result.error.message;
        notifyListeners();
      }
    } catch (e) {
      _logOutError = e.message;
      notifyListeners();
    }
  }
}
