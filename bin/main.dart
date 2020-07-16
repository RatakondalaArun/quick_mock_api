import 'dart:convert';
import 'dart:io';
// import 'package:angel_cors/angel_cors.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';
// import 'package:angel_static/angel_static.dart';
// import 'package:file/local.dart' as fileSystem;

import 'mock/mock_user.dart';

main() async {
  final int port = int.tryParse(Platform.environment['PORT'] ?? '8080');
  final InternetAddress address = InternetAddress.anyIPv4;
  final Angel app = Angel();
  final AngelHttp http = AngelHttp(app);
  // final fileSystem.LocalFileSystem fs = const fileSystem.LocalFileSystem();

  // final VirtualDirectory vDir = VirtualDirectory(
  //   app,
  //   fs,
  //   allowDirectoryListing: false,
  //   source: fs.currentDirectory.childDirectory('bin\\web'),
  // );
  // print(vDir.source);
  // app.fallback(cors());

  app.all(
    '*',
    (req, res) {
      print('[${DateTime.now()}]\t${req.ip}\t${req.method}\t${req.path}');
      return true;
    },
  );

  // index.html
  // app.all('/*', vDir.handleRequest);

  app.group('/api', (router) {
    router.get('/mirror', (req, res) {
      res.headers.addAll({'content-type': 'application/json'});
      return res.write(
        jsonEncode(
          {
            'status_code': 200,
            'is_error': false,
            'data': req.params,
          },
        ),
      );
    });

    router.post('/mirror', (req, res) async {
      res.headers.addAll({'content-type': 'application/json'});
      await req.parseBody();
      return res.write(
        jsonEncode(
          {
            'status_code': 200,
            'is_error': false,
            'data': req.bodyAsMap,
          },
        ),
      );
    });

    router.get('/users', (req, res) {
      res.headers.addAll({'content-type': 'application/json'});
      if (int.parse(req.queryParameters['limit'] ?? '0') > 50) {
        return (res..statusCode = 413).write(jsonEncode({
          'status_code': 413,
          'is_error': true,
          'message': 'Users are limited to 50.',
        }));
      }
      return res.write(jsonEncode({
        'status_code': 200,
        'is_error': false,
        'data': MockUser.generateAsMap(
            limit: int.parse(req.queryParameters['limit'] ?? '0')),
      }));
    });

    router.get('/users/int:id', (req, res) {
      res.headers.addAll({'content-type': 'application/json'});
      return res.write(jsonEncode({
        'status_code': 200,
        'is_error': false,
        'data': MockUser.generateWithId(req.params['id']).toMap(),
      }));
    });
  });

  // redirects
  app.all('/api/*', (req, res) => AngelHttpException.notFound());
  app.all('/api', (req, res) => res.redirect('/'));
  app.all('favicon.ico', (req, res) => AngelHttpException.notFound());

  await http.startServer(address, port);
  print('Running at port ${http.server.port}');
}
