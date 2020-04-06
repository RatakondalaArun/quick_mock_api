import 'dart:io';

class ResponseHandlers {
  void sendResponse(HttpResponse response, Object writeObject,
      {Object contentType = 'application/json;charset=utf-8',
      int statusCode = 200}) {
    //todo:send and close connection;
    response
      ..headers.set(HttpHeaders.contentTypeHeader, contentType)
      ..statusCode = statusCode
      ..write(writeObject)
      ..close();
  }
}
