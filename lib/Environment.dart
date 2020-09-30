
import 'package:meta/meta.dart';
import 'services/API.dart';

/// A class for controlling the global app environment.
class Environment {

  /// The current environment object.
  static Environment _currentEnvironment;

  /// This environment's `API`.
  final API api;

  Environment({@required this.api});

  /// Returns the current environment.
  static Environment current() {
    return _currentEnvironment;
  }

  /// Sets the current environment.
  /// 
  /// Call this method only once, and call it during startup before any rendering occurs.
  static void set(Environment environment) {
    if (_currentEnvironment == null) {
      _currentEnvironment = environment;
    }
  }
}