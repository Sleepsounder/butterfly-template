import 'package:butterfly/app/locator.dart';
import 'package:butterfly/services/Auth0AppAuthService.dart';
import 'package:butterfly/services/AuthorizationToken.dart';
import 'package:butterfly/services/SecureStorageService.dart';
import 'package:butterfly/services/UserInfoService.dart';
import 'package:butterfly/ui/views/auth0UniversalLogin/loginWithAppauth_viewModel.dart';
import 'package:butterfly/utils/Result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../setup/test_data.dart';
import '../setup/test_helpers.dart';

void main() {
 group('LoginwithappauthViewmodelTest -', (){
   setUp(() => registerAllServices());
   tearDown(() => unregisterAllServices());
   group('Constructed -', () {
    test('When constructed loginError should be empty', () {
      var model = LoginWithAppauthViewModel();
      expect(model.logInError, "");
   
    });
    test('When constructed signUpError should be empty', () {
      var model = LoginWithAppauthViewModel();
      expect(model.signUpError, "");
    });
    test('When constructed logOutError should be empty', () {
      var model = LoginWithAppauthViewModel();
      expect(model.logOutError, "");
    });
   });

   group('Login action -', () {
    test('on Login action auth0Service login is called', () {
      var auth0appAuthService = getAndRegisterAuth0AppAuthServiceMock();
      var model = LoginWithAppauthViewModel();
      model.loginAction();
      verify(auth0appAuthService.login());
    });
    test('If auth0Service login returns isSuccess false logInError is not empty', () async {
      getAndRegisterAuth0AppAuthServiceMock(loginIsSuccess: false);
      var model = LoginWithAppauthViewModel();
      await model.loginAction();
      expect(model.logInError, ExpectedResults.expectedLoginSuccessFalseResult.error.message);
    });
    test('If auth0Service login returns isSuccess true secureStorage writeToken is called ', () async {
      var secureStorageService = getAndRegisterSecureStorageServiceMock();
      var model = LoginWithAppauthViewModel();
      await model.loginAction();
      verify(secureStorageService.writeToken(ExpectedResults.expectedLoginSuccessTrueResult.value));
    });
    test('If auth0Service login returns isSuccess true auth0Service getUserDetails is called ', () async {
      var auth0AppAuthService = getAndRegisterAuth0AppAuthServiceMock();
      var model = LoginWithAppauthViewModel();
      await model.loginAction();
      verify(auth0AppAuthService.getUserDetails(ExpectedResults.expectedLoginSuccessTrueResult.value.accessToken));
    });
    test('If auth0Service login returns isSuccess true auth0Service getUserDetails is called ', () async {
      var auth0AppAuthService = getAndRegisterAuth0AppAuthServiceMock();
      var model = LoginWithAppauthViewModel();
      await model.loginAction();
      verify(auth0AppAuthService.getUserDetails(ExpectedResults.expectedLoginSuccessTrueResult.value.accessToken));
    });
    test('If auth0Service getUserDetails throws exception logInError is not empty', () async {
      getAndRegisterAuth0AppAuthServiceMock(getUserInfoReturnsValidUserInfo: false);
      var model = LoginWithAppauthViewModel();
      await model.loginAction();
      isNot(model.logInError.length == 0);
    });
    test('If auth0Service getUserDetails returns valid user info userService updateName is called', () async {
      var userInfoService = getAndRegisterUserInfoServiceMock();
      var model = LoginWithAppauthViewModel();
      await model.loginAction();
      verify(userInfoService.updateName(ExpectedResults.expectedValidUserInfo["nickname"]));
    });
   });
 });
}