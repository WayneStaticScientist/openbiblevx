import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

class BibleHttpServer {
  static InternetAddress loopAddress = InternetAddress.loopbackIPv4;
  static HttpServer? server;
  static host(String indexDirectory) async {
    // Create a handler that serves files from the specified directory.
    final handler = createStaticHandler(
      indexDirectory,
      serveFilesOutsidePath: true,
      listDirectories: true
    );

    // Configure middleware (optional, but good practice).
    final middleware = Pipeline()
        .addMiddleware(logRequests()) // Logs each request to the console.
        .addHandler(handler);

    const port = 8080;
    // Start the HTTP server.
    BibleHttpServer.server = await io.serve(middleware, loopAddress, port);
  }
}
