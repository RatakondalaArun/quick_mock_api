import 'dart:io';

import 'routes.dart';

main() async {
  final port = Platform.environment['PORT'] ?? '8080';

  final InternetAddress address = InternetAddress.loopbackIPv4;

  HttpServer requestServer = await HttpServer.bind(address, int.parse(port));
  print('server is running at port ${requestServer.port}');
  await for (HttpRequest request in requestServer) {
    ServerRoutes routes = ServerRoutes();
    routes.send(request);
  }
}
