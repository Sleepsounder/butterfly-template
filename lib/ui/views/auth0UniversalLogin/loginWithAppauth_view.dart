import 'package:butterfly/ui/views/AppBar/appBarr_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'loginWithAppauth_viewModel.dart';

class LoginWithAppauthView extends StatelessWidget {
  const LoginWithAppauthView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginWithAppauthViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: MainAppBar.make(context),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              
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
      viewModelBuilder: () => LoginWithAppauthViewModel(),
    );
  }

  
}