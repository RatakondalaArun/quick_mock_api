import 'dart:io';

import 'request_handlers.dart';

class ServerRoutes {
  static RequestHandlers _handlers = RequestHandlers();

  final Map<String, dynamic> _routes = {
    'GET': {
      '/': (HttpRequest request) {
        _handlers.handleApiMirror(request);
      },
      '/api/mirror': (HttpRequest request) {
        _handlers.handleApiMirror(request);
      },
      '/api/user': (HttpRequest request) {
        _handlers.handleSingleUser(request);
        //returns a single user
      },
      '/api/users': (HttpRequest request) {
        _handlers.handlemultiUser(request);
        //retrns a list(Array) of users
      },
      '/api/user/get': (HttpRequest request) {
        _handlers.handleGetuserWithId(request);
      }
    },
    'POST': {
      '/api/mirror': (HttpRequest request) {
        _handlers.handleApiMirror(request);
      },
      '/': (HttpRequest request) {
        _handlers.handleOtherRequests(request);
      }
    },
    'NA': (HttpRequest request) {
      _handlers.handleInvalidPath(request);
    }
  };

  void send(HttpRequest request) {
    print(request.method);
    print(request.uri.path);
    print(_routes.containsKey(request.method));
    if (_routes.containsKey(request.method)) {
      if (_routes[request.method].containsKey(request.uri.path)) {
        _routes[request.method][request.uri.path](request);
      } else {
        _routes['NA'](request);
      }
    } else {
      _routes['NA'](request);
    }
  }
}
