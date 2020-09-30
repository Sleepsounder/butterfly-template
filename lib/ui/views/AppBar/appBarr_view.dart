import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'appBar_viewModel.dart';

class AppBarView extends StatelessWidget {
  const AppBarView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppBarViewModel>.reactive(
      builder: (context, model, child) => Center(
          child: 
              Text(model.name)
      ),
      viewModelBuilder: () => AppBarViewModel(),
    );
  }
}

class MainAppBar {

  static PreferredSizeWidget make(
    BuildContext context) {
    return AppBar(
      title: AppBarView()
    );
  }

  MainAppBar._();
}
