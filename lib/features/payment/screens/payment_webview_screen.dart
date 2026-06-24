import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Loads a Midtrans Snap [redirectUrl] in a WebView and reports the result.
///
/// Midtrans redirects to the configured `finish` URL when the flow ends,
/// appending `?order_id=&status_code=&transaction_status=`. We intercept any
/// navigation to [finishUrlPrefix], read `transaction_status`, and pop it back
/// to the caller. If the user closes the page, we pop `null`.
class PaymentWebViewScreen extends StatefulWidget {
  final String redirectUrl;
  final String finishUrlPrefix;

  const PaymentWebViewScreen({
    super.key,
    required this.redirectUrl,
    this.finishUrlPrefix = 'https://geraijasa.app/payment/finish',
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _loading = true;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _loading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
          onNavigationRequest: (request) {
            if (request.url.startsWith(widget.finishUrlPrefix)) {
              _handleFinish(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.redirectUrl));
  }

  void _handleFinish(String url) {
    if (_finished) return;
    _finished = true;
    final status = Uri.parse(url).queryParameters['transaction_status'];
    if (mounted) Navigator.of(context).pop(status);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Returning null signals "user closed without finishing".
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pembayaran', style: TextStyle(color: Color(0xFF14241F), fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFF14241F)),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_loading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
