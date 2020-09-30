import 'package:butterfly/services/AuthorizationToken.dart';
import 'package:butterfly/services/exceptions/Auth0Error.dart';
import 'package:butterfly/utils/Result.dart';

class ExpectedResults{
  static Result<AuthorizationToken,Auth0Error> expectedLoginSuccessFalseResult =  Result.failure(Auth0Error("ErrorMessage", 1234));
  static Result<AuthorizationToken,Auth0Error> expectedLoginSuccessTrueResult = Result.success(
          AuthorizationToken("accessToken", "refreshToken", null, "idToken"));
  static Map<String,String> expectedValidUserInfo = {"nickname":"userNickName"};
}