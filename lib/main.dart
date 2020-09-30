import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked_services/stacked_services.dart';

import 'Environment.dart';
import 'app/locator.dart';
import 'app/router.gr.dart';
import 'services/APIService.dart';
import 'services/AuthenticationToken.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();  
  AuthenticationToken token;

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

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Butterfly App',
      theme: ThemeData(       
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,        
      ),
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: Router().onGenerateRoute,
    );
  }
}