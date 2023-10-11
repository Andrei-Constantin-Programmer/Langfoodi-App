part of 'api.dart';

class ResponseError {
  static String? getErrorMessageFromCode(String defaultErrorMessage, http.Response response) {
    String? errorMessage;
    switch(response.statusCode) {
      case 500:
        errorMessage = defaultErrorMessage;
        break;
      case 400:
        errorMessage = response.body.replaceAll('"', '');
        break;
      default:
        errorMessage = null;
        break;
    }

    errorMessage = response.body == "false" ? defaultErrorMessage : errorMessage;
    return errorMessage;
  }
}