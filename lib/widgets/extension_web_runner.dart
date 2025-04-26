import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ExtensionWebRunner extends StatefulWidget {
  final String path;
  const ExtensionWebRunner({super.key, required this.path});
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
          );
    controller.loadFile("file:///${widget.path}");
    _addMessageChannel();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller);
  }

  _addMessageChannel() {
    controller.addJavaScriptChannel(
      'oSnackBar',
      onMessageReceived: (JavaScriptMessage message) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message.message),
              duration: const Duration(seconds: 2),
            ),
          );
        });
      },
    );
  }
}
