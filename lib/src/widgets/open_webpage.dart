import 'dart:io';

import 'package:flutter/material.dart';
import 'package:interstellar/src/utils/utils.dart';
import 'package:interstellar/src/utils/variables.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

void openWebpagePrimary(BuildContext context, Uri uri) {
  launchUrl(uri);
}

void openWebpageSecondary(BuildContext context, Uri uri) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(l(context).openLink),
      content: SelectableText(uri.toString()),
      actions: <Widget>[
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l(context).cancel),
        ),
        FilledButton.tonal(
          onPressed: () {
            Navigator.pop(context);

            if (Platform.isAndroid || Platform.isIOS) {
              Share.shareUri(uri);
            } else {
              Share.share(uri.toString());
            }
          },
          child: Text(l(context).share),
        ),
        if (isWebViewSupported)
          FilledButton.tonal(
            onPressed: () {
              Navigator.pop(context);

              var controller = WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..loadRequest(uri);

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(),
                    body: WebViewWidget(controller: controller),
                  ),
                ),
              );
            },
            child: Text(l(context).webView),
          ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);

            launchUrl(uri);
          },
          child: Text(l(context).browser),
        ),
      ],
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsOverflowButtonSpacing: 8,
      actionsOverflowDirection: VerticalDirection.up,
    ),
  );
}
