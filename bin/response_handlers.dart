import 'dart:convert';
import 'dart:io';

import 'exception/exceptions.dart';

class ResponseHandlers {
  void sendResponse(HttpResponse response, Object writeObject,
      {Object contentType = 'application/json;charset=utf-8',
      int statusCode = 200}) {
    //send and close connection;
    try {
      try {
        String jsonEncodedData = jsonEncode(writeObject);
        response
          ..headers.set(HttpHeaders.contentTypeHeader, contentType)
          ..headers.add('Access-Control-Allow-Headers', '*')
          ..headers.add("Access-Control-Allow-Origin", "*")
          ..headers.add(
              "Access-Control-Allow-Methods", "POST,GET,DELETE,PUT,OPTIONS")
          ..statusCode = statusCode
          ..write(jsonEncodedData)
          ..close();
      } catch (e) {
        throw InternalServerException();
      }
    } catch (e) {
      if (e is QuickMockApiException) {
        response
          ..headers.set(HttpHeaders.contentTypeHeader, contentType)
          ..statusCode = e.statusCode
          ..write(e.toJson())
          ..close();
      } else {
        response
          ..headers.set(HttpHeaders.contentTypeHeader, contentType)
          ..statusCode = e.statusCode
          ..write(jsonEncode({
            'success': false,
            'status_code': 500,
            'message': 'Internal server error'
          }))
          ..close();
      }
    }
  }
}
