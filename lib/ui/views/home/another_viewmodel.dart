
import 'package:stacked/stacked.dart';

class AnotherViewModel extends BaseViewModel {
  String _title = 'Butterfly Another View';
  String get title => _title;

  int _counter = 0;
  int get counter => _counter;

  void incrementCounter() {
    _counter++;
    notifyListeners();
  }
}