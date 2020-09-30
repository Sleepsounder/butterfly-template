import 'package:butterfly/Environment.dart';
import 'package:butterfly/app/locator.dart';
import 'package:butterfly/main.dart';
import 'package:butterfly/services/APIService.dart';
import 'package:butterfly/services/AuthenticationToken.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthenticationToken token;
  await GlobalConfiguration().loadFromAsset("app_settings");

  Environment.set(Environment(
    api: APIService(
      baseURL: "localhost:5000/api/",
      retrieveToken: () {
        return Future.value(token.idToken);
      },
    )
  ));

  setupLocator();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(MyApp()));
}
