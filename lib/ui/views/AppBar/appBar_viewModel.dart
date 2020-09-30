import 'package:butterfly/services/UserInfoService.dart';
import 'package:stacked/stacked.dart';

import '../../../app/locator.dart';

class AppBarViewModel extends ReactiveViewModel {
  final _userInfoService = locator<UserInfoService>();
  String get name => _userInfoService.name;
  @override
  List<ReactiveServiceMixin> get reactiveServices => [_userInfoService];
}