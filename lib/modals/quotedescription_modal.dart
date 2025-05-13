import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:todaily/scrollconfiguration_logic.dart';
import 'package:todaily/widgets/quote_widget.dart';
import 'package:url_launcher/link.dart';

class QuoteDescriptionModal extends StatelessWidget {
  const QuoteDescriptionModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Header.
          Text(
            'Quote by ${Quote.sAuthor.watch(context) ?? 'Unknown'}',
            style: const TextStyle(fontSize: 18),
          ),
          const Divider(),
          // Scrollable content.
          Flexible(
            child: CustomScrollConfiguration(
              child: SingleChildScrollView(
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
          // Footer.
          const Divider(),
          const SizedBox(height: 8),
          // Footer section
          Row(
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
        ],
      ),
    );
  }
}
