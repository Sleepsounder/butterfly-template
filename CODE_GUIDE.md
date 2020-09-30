# Butterfly Flutter template Code Guide

This repo contains boilerplate project for Flutter application.

#### `Environment`

At a high level, the `Environment` API provides basic dependency injection.

It consists of two primary methods. The first, `Environment.set(...)`, is only called once (during startup in `main()`), to load the environment based on build environment variables, etc.

The second, `Environment.current()`, is the more frequent use case.

```dart
Environment env = Environment.current();
```

`Environment.current()` is a super-cheap operation. It's safe (and encouraged) to call this function anywhere, including within the `build` method on a widgets.

Some uses of the returned `Environment` object:

- Interacting with the API layer

  ```dart
  final api = Environment.current().api;

  api.doSomething().then(result => {
    // handle result
  });

  // Or, using async/await
  final result = await api.doSomething();


#### `APIService`

The `API` interface describes an object that fulfills the asynchronous API contract required by the app.

Primary implementations of this interface:

- `APIService`, which acts as a client to the REST API.

Generally, usage of the API should be done through the `Environment` 

_Example_

```dart
abstract class API {
  ...
  /// Logs in a user with the provided `email` and `password`.
  Future<Result<User, APIError>> login({ @required String email, @required String password });
  ...
}
class APIService {

  @override
  Future<Result<User, APIError>> login({ @required String email, @required String password }) async {
    return _request(
         url: 'Login',
         method: HTTPMethod.get,
         decode: (json) => ParseUserFromResult(json));
 }
}

final api = Environment.current().api // `api` is of type `API`.

// Usage
api.login(email: 'developer@test.com', password: 'mypassword')
  .then((result) {
    if (result.isSuccess) {
      ...
    }
  });

// Or, using async/await
final loginResult = await api.login('developer@test.com', 'mypassword')
if (loginResult.isSuccess) {
  ...
}

```