import 'dart:convert';
import 'package:butterfly/services/API.dart';
import 'package:butterfly/services/exceptions/APIError.dart';
import 'package:butterfly/utils/Result.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as Http;

/// Enumerates the various HTTP methods.
enum HTTPMethod {
  get,
  delete,
  put,
  patch,
  post,
}

/// Sends an HTTP request to the API using the provided [url], HTTP
/// [method], [headers], [encoding], and request [body].
Future<Http.Response> _httpRequest({
    @required String url,
    @required HTTPMethod method,
    Map<String, String> headers,
    Encoding encoding,
    dynamic body
 }) async {
  switch (method) {
    case HTTPMethod.get:
      return await Http.get(url, headers: headers);
    case HTTPMethod.delete:
      return await Http.delete(url, headers: headers);
    case HTTPMethod.put:
      return await Http.put(url,
          headers: headers, body: body, encoding: encoding);
    case HTTPMethod.patch:
      return await Http.patch(url,
          headers: headers, body: body, encoding: encoding);
    case HTTPMethod.post:
      return await Http.post(url,
          headers: headers, body: body, encoding: encoding);
    default:
      throw 'Unsupported HTTP method.';
  }
}
/// An `API` implementation for calling REST web API.
class APIService implements API {
  /// The base host URL for the API.
  final String baseURL;

  final Future<String> Function() retrieveToken;

  /// Creates a new instance of the client, tied to the provided `baseURL`.
  APIService({@required this.baseURL,  @required this.retrieveToken});

  /// Sends an HTTP request to the given API using the provided relative
  /// [url], HTTP [method], [decode] function, and [parameters].
  Future<Result<T, APIError>> _request<T>(
      {@required String url,
      @required HTTPMethod method,
      @required Function decode,
      Map<String, dynamic> parameters}) async {
    try {

      // 1. Retrive authorization token
      final authToken = await retrieveToken();

      // 2. Send HTTP request.
      final response = await _httpRequest(
        url: this.baseURL + url,
        method: method,
        headers: {
          'content-type': 'application/json',
          'accept': 'text/plain',
          'authorization': 'Bearer $authToken',
        },
        body: json.encode(parameters)
      );

      // 3. Check for non-200 level response.
      if (!(response.statusCode >= 200 && response.statusCode <= 299)) {
        APIError error;
        switch (response.statusCode) {
          case 401:
            error = APIError.notAuthenticated();
            break;
          case 403:
            error = APIError.forbidden();
            break;
          case 404:
            error = APIError.notFound();
            break;
          default:
            error = APIError(
                statusCode: response.statusCode,
                message: response.bodyBytes.toString());
        }
        return Result.failure(error);
      }

      return Result.success(decode(json.decode(response.body)));
    } catch (error) {
      return Result.failure(APIError(message: error.message, statusCode: null));
    }
  }
}

