import 'dart:io';

import 'routes.dart';

main() async {
  const port = 8080;
  final InternetAddress address = InternetAddress.loopbackIPv6;

  HttpServer requestServer = await HttpServer.bind(address, port);
  print('server is running at port ${requestServer.port}');
  await for (HttpRequest request in requestServer) {
    ServerRoutes routes = ServerRoutes();
    routes.send(request);
  }
}
