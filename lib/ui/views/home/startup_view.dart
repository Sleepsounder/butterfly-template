import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'startup_viewmodel.dart';

class StartupView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartupViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(          
          title: Text(model.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text('Startup View\r\nlook at lib\\app\\router.dart to see how you got here.\r\npress the button to be taken to the next view.'), 
            ),
            RaisedButton(
              onPressed: () {
                model.navigateToLoginWithAppauthView();
              },
              child: Text('Login view with appAuth'),
            ),
            RaisedButton(
              onPressed: () {
                model.navigateToLoginWithWebView();
              },
              child: Text('Login view with web view'),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => model.navigateToAnotherView(),
        ),
      ),
      viewModelBuilder: () => StartupViewModel(),
    );
  }
}