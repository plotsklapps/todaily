import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:todaily/widgets/quote_widget.dart';
import 'package:url_launcher/link.dart';

class QuoteDescriptionModal extends StatelessWidget {
  const QuoteDescriptionModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Quote by ${Quote.sAuthor.watch(context) ?? 'Unknown'}',
          style: const TextStyle(fontSize: 18),
        ),
        const Divider(),
        Flexible(
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(
              physics: const BouncingScrollPhysics(),
              dragDevices: <PointerDeviceKind>{
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.stylus,
                PointerDeviceKind.trackpad,
              },
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  (Quote.sDescription.watch(context) == null ||
                          Quote.sDescription.watch(context)!.isEmpty)
                      ? 'No originator description '
                          'available, but you can visit the '
                          'source to find out more.'
                      : Quote.sDescription.watch(context)!,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),

        const Divider(),
        const SizedBox(height: 8),
        // Footer section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Pop the bottomsheet.
                    Navigator.pop(context);
                  },
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Link(
                  uri: Uri.parse(Quote.sQuoteUrl.watch(context) ?? ''),
                  target: LinkTarget.blank,
                  builder: (BuildContext context, FollowLink? followLink) {
                    return FilledButton(
                      onPressed: followLink,
                      child: const Text('Source'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
