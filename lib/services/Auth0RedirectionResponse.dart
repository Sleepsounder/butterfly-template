import 'package:butterfly/services/AuthorizationToken.dart';

class Auth0RediredctionResponse {
  final bool redirectedBackToApp;
  final AuthorizationToken authorizationToken;

  Auth0RediredctionResponse(this.redirectedBackToApp, this.authorizationToken);
  
}
