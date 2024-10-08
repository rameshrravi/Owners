import 'dart:io';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fuodz/services/toast.service.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:fuodz/views/pages/payment/custom_webview.page.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:fuodz/extensions/context.dart';

class MyChromeSafariBrowser extends ChromeSafariBrowser {
  @override
  void onOpened() {
    print("ChromeSafari browser opened");
  }

  @override
  void onCompletedInitialLoad(bool? value) {
    print("ChromeSafari browser initial load completed");
  }

  @override
  void onClosed() {
    print("ChromeSafari browser closed");
  }
}

class PaymentViewModel extends MyBaseViewModel {
  refreshDataSet() {}
  //
  openEmbededWebpageLink(String url) async {
    //
    try {
      ChromeSafariBrowser browser = new MyChromeSafariBrowser();
      await browser.open(
        url: WebUri.uri(Uri.parse(url)),
        settings: ChromeSafariBrowserSettings(
          enableUrlBarHiding: false,
          barCollapsingEnabled: true,
          shareState: CustomTabsShareState.SHARE_STATE_OFF,
        ),
      );
    } catch (error) {
      await launchUrlString(url);
    }
    //
    refreshDataSet();
  }

  Future<dynamic> openWebpageLink(
    String url, {
    bool external = false,
    bool embeded = false,
  }) async {
    //
    if (embeded) {
      return openEmbededWebpageLink(url);
    }
    //
    if (!embeded && (Platform.isIOS || external)) {
      await launchUrlString(
        url,
        webViewConfiguration: WebViewConfiguration(),
      );
      return;
    }
    final result = await viewContext.push(
      (context) => CustomWebviewPage(
        selectedUrl: url,
      ),
    );

    refreshDataSet();
    return result;
  }

  Future<dynamic> openExternalWebpageLink(String url) async {
    try {
      final result = await launchUrlString(
        url,
        mode: LaunchMode.externalApplication,
      );
      refreshDataSet();
      return result;
    } catch (error) {
      ToastService.toastError("$error");
    }
    return null;
  }
}
