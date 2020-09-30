import 'package:butterfly/app/locator.dart';
import 'package:butterfly/services/Auth0AppAuthService.dart';
import 'package:butterfly/services/SecureStorageService.dart';
import 'package:butterfly/services/UserInfoService.dart';
import 'package:mockito/mockito.dart';

import 'test_data.dart';

class Auth0AppAuthServiceMock extends Mock implements Auth0AppAuthService {}

Auth0AppAuthService getAndRegisterAuth0AppAuthServiceMock(
    {bool loginIsSuccess = true, bool getUserInfoReturnsValidUserInfo = true}) {
  _removeRegistationIfExists<Auth0AppAuthService>();
  var auth0appAuthServiceMock = Auth0AppAuthServiceMock();
  when(auth0appAuthServiceMock.login()).thenAnswer((realInvocation) {
    if (loginIsSuccess) {
      return Future.value(ExpectedResults.expectedLoginSuccessTrueResult);
    } else {
      return Future.value(ExpectedResults.expectedLoginSuccessFalseResult);
    }
  });
  if (getUserInfoReturnsValidUserInfo) {
    when(auth0appAuthServiceMock.getUserDetails(ExpectedResults.expectedLoginSuccessTrueResult.value.accessToken))
        .thenAnswer((realInvocation) => Future.value(ExpectedResults.expectedValidUserInfo));
  }
  else {
    when(auth0appAuthServiceMock.getUserDetails(ExpectedResults.expectedLoginSuccessTrueResult.value.accessToken))
        .thenThrow(Exception("ErrorMessage"));
  }
  locator.registerSingleton<Auth0AppAuthService>(auth0appAuthServiceMock);
  return auth0appAuthServiceMock;
}

class SecureStorageServiceMock extends Mock implements SecureStorageService {}

SecureStorageService getAndRegisterSecureStorageServiceMock() {
  _removeRegistationIfExists<SecureStorageService>();
  var secureStorageServiceMock = SecureStorageServiceMock();
  locator.registerSingleton<SecureStorageService>(secureStorageServiceMock);
  return secureStorageServiceMock;
}

class UserInfoServiceMock extends Mock implements UserInfoService {}

UserInfoService getAndRegisterUserInfoServiceMock() {
  _removeRegistationIfExists<UserInfoService>();
  var userInfoServiceMock = UserInfoServiceMock();
  locator.registerSingleton<UserInfoService>(userInfoServiceMock);
  return userInfoServiceMock;
}

void registerAllServices() {
  getAndRegisterAuth0AppAuthServiceMock();
  getAndRegisterSecureStorageServiceMock();
  getAndRegisterUserInfoServiceMock();
}

void unregisterAllServices() {
  locator.unregister<Auth0AppAuthService>();
  locator.unregister<SecureStorageService>();
  locator.unregister<UserInfoService>();
}

void _removeRegistationIfExists<T>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
