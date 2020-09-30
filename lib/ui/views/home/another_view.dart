import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'another_viewmodel.dart';

class AnotherView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AnotherViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(          
          title: Text(model.title),
        ),
        body: Center(          
          child: Column(            
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '${model.counter}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: model.incrementCounter,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
      viewModelBuilder: () => AnotherViewModel(),
    );
  }
}
