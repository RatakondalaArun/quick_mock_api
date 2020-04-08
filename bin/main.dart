import 'dart:io';

import 'routes.dart';

main() async {
  final port = Platform.environment['PORT'] ?? '8080';

  final InternetAddress address = InternetAddress.anyIPv4;

  HttpServer requestServer = await HttpServer.bind(address, int.parse(port));
  print('Dart server is running at port ${requestServer.port}');
  await for (HttpRequest request in requestServer) {
    print(
        'recived a request-------------------------------------------------------');
    ServerRoutes routes = ServerRoutes();
    routes.send(request);
    print(
        'request ---------------------------END------------------------------');
  }
}
