import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ExtensionWebRunner extends StatefulWidget {
  final String path;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  const ExtensionWebRunner({
    super.key,
    required this.path,
    required this.scaffoldMessengerKey,
  });
  @override
  State<ExtensionWebRunner> createState() => _ExtensionWebRunnerState();
}

class _ExtensionWebRunnerState extends State<ExtensionWebRunner> {
  late WebViewController controller;
  @override
  void initState() {
    super.initState();
    _runLoader();
  }

  _runLoader() async {
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..addJavaScriptChannel(
            'OSnackBar',
            onMessageReceived: (JavaScriptMessage message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message.message),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          )
          ..addJavaScriptChannel("OTitlebar", onMessageReceived: (message) {})
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading bar.
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onHttpError: (HttpResponseError error) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadFile("file:///${widget.path}");
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller);
  }
}
