import 'package:injectable/injectable.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';

@lazySingleton
class UserInfoService with ReactiveServiceMixin{
  RxValue<String> _name = RxValue<String>(initial: "");
  String get name => _name.value;

  static final UserInfoService _instance = UserInfoService._internal();
    // UserInfoService() {
    //   listenToReactiveValues([_name]);
    // }
    factory UserInfoService(){
      return _instance;
    }
    void updateName(String name){
      _name.value = name;
    }
  
    UserInfoService._internal(){
      listenToReactiveValues([_name]);
    }
}