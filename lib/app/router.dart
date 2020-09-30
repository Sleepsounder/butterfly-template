import 'package:auto_route/auto_route_annotations.dart';
import 'package:butterfly/ui/views/auth0UniversalLogin/LoginWithWebView_view.dart';
import 'package:butterfly/ui/views/auth0UniversalLogin/loginWithAppauth_view.dart';
import 'package:butterfly/ui/views/home/another_view.dart';
import 'package:butterfly/ui/views/home/startup_view.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    AdaptiveRoute(page: StartupView, initial: true),
    AdaptiveRoute(page: AnotherView),
    AdaptiveRoute(page: LoginWithAppauthView),
    AdaptiveRoute(page: LoginWithWebViewView)
  ],
)
class $Router {}
