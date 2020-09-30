
import 'package:butterfly/app/locator.dart';
import 'package:butterfly/app/router.gr.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/router.gr.dart';

class StartupViewModel extends BaseViewModel { 
  String _title = 'Butterfly Startup View';
  String get title => _title;

  final NavigationService _navigationService = locator<NavigationService>(); //This is using get_it. The locator.dart file defines the function that registers all the services when the app begins (main.dart).
                                                                             //The injectable package generates the locator.config.dart file based on third_party_services.dart thats lists the services to be registered. 


  Future navigateToAnotherView() async{
    await _navigationService.navigateTo(Routes.anotherView); //This is possible because of auto_route. Look in router.dart to see how this is defined. 
                                                             //And in router.gr.dart to see the code that is generated for you automatically.
                                                             

  }

  Future navigateToLoginWithAppauthView() async {
    await _navigationService.navigateTo(Routes.loginWithAppauthView);
  }

  Future navigateToLoginWithWebView() async {
    await _navigationService.navigateTo(Routes.loginWithWebViewView);
  }

}