import 'package:butterfly/ui/views/AppBar/appBarr_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'LoginWithWebView_viewModel.dart';


class LoginWithWebViewView extends StatelessWidget {
  const LoginWithWebViewView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginWithWebViewViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
          appBar: MainAppBar.make(context),
              body: model.showUniversalLogin
                  ? WebView(
                      initialUrl: model.url,
                      javascriptMode: JavascriptMode.unrestricted,
                      onPageFinished: (url) => model.onPageFinished(url),
                      navigationDelegate: (NavigationRequest request) async {
                        return await model.onNavigation(request);
                      })
                  : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("At time of example creation web_view package is in developer preview state. Check for update or use alternative.", textAlign: TextAlign.center),
              RaisedButton(
                onPressed: () {
                  model.loginAction();
                },
                child: Text('Log In'),
              ),
              Text(model.logInError),
              RaisedButton(
                onPressed: () {
                  model.signUpAction();
                },
                child: Text('Sign Up'),
              ),
              Text(model.signUpError),
              RaisedButton(
                onPressed: () {
                  model.logOutAction();
                },
                child: Text('Log Out'),
              ),
              Text(model.logOutError),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => LoginWithWebViewViewModel(),
    );
  }

  
}