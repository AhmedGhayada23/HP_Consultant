import 'package:flutter/material.dart';
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/dialogs_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewView extends StatefulWidget {
  final String paymentUrl;
  const PaymentWebViewView({super.key, required this.paymentUrl});

  @override
  State<PaymentWebViewView> createState() => _PaymentWebViewViewState();
}

class _PaymentWebViewViewState extends State<PaymentWebViewView> {
  late final WebViewController _controller;
  bool _loading = true;
  bool _handled = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            _handleUrl(url);
            if (mounted) setState(() => _loading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
          onUrlChange: (change) => _handleUrl(change.url ?? ''),
          onNavigationRequest: (request) {
            _handleUrl(request.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _handleUrl(String url) {
    if (_handled) return;
    final u = url.toLowerCase();

    final isSuccess = u.contains('success') ||
        u.contains('payment-success') ||
        u.contains('completed') ||
        u.contains('thank');
    final isCancel = u.contains('cancel') || u.contains('failed');

    if (isSuccess) {
      _handled = true;
      final loc = AppLocalizations.of(context)!;
      // شاشة نجاح الدفع، وعند "Done" الانتقال لصفحة دوراتي
      showRequestSubmittedDialog(
        context,
        title: loc.payment_successful,
        subTitle: loc.payment_success_subtitle,
        textBtn: loc.done,
        onDone: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            MyRoutes().myCouresesView,
            (route) => route.isFirst,
          );
        },
      );
    } else if (isCancel) {
      _handled = true;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        iconTheme: const IconThemeData(color: AppColor.whiteColor),
        title: Text(
          'Payment',
          style: MyTextStyle().textStyleSemiBold16().copyWith(
                color: AppColor.whiteColor,
              ),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading)
            const Center(
              child: CircularProgressIndicator(color: AppColor.k1primeryColor),
            ),
        ],
      ),
    );
  }
}
