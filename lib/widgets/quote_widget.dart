import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:signals/signals_flutter.dart';
import 'package:todaily/modals/quotedescription_modal.dart';
import 'package:todaily/state/loading_signal.dart';
import 'package:todaily/widgets/modal_widget.dart';

class QuoteWidget extends StatefulWidget {
  const QuoteWidget({super.key});

  @override
  State<QuoteWidget> createState() {
    return _QuoteWidgetState();
  }
}

class _QuoteWidgetState extends State<QuoteWidget> {
  @override
  void initState() {
    super.initState();
    Quote.fetchQuote();
  }

  @override
  Widget build(BuildContext context) {
    // While loading the quote, show a loading indicator. sLoading.value is
    // toggled in Quote.fetchQuote().
    return sLoading.watch(context)
        ? const SizedBox(
          height: 32,
          child: Center(child: LinearProgressIndicator()),
        )
        : Column(
          children: <Widget>[
            Text(
              '"${Quote.sQuote.watch(context) ?? 'No quote available'}"',
              style: const TextStyle(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () {
                // Show the QuoteDescriptionModal.
                showModal(
                  context: context,
                  child: const QuoteDescriptionModal(),
                );
              },
              child: Text('- ${Quote.sAuthor.watch(context) ?? 'Unknown'}'),
            ),
          ],
        );
  }
}

class Quote {
  static final Signal<String?> sQuote = Signal<String?>(
    '',
    debugLabel: 'sQuote',
  );
  static final Signal<String?> sAuthor = Signal<String?>(
    '',
    debugLabel: 'sAuthor',
  );
  static final Signal<String?> sDescription = Signal<String?>(
    '',
    debugLabel: 'sDescription',
  );
  static final Signal<String?> sQuoteUrl = Signal<String?>(
    '',
    debugLabel: 'sQuoteUrl',
  );

  static Future<void> fetchQuote() async {
    const String url =
        'https://quotes15.p.rapidapi.com/quotes/random/?language_code=en';
    const Map<String, String> headers = {
      'x-rapidapi-key': '4e9b09616amshcb8bc4ff62ef298p15f8d8jsn8527db553cab',
      'x-rapidapi-host': 'quotes15.p.rapidapi.com',
    };
    final Logger logger = Logger();

    try {
      sLoading.value = true;
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            json.decode(response.body) as Map<String, dynamic>;
        sQuote.value = data['content'] as String?;
        sAuthor.value =
            (data['originator'] as Map<String, dynamic>)['name'] as String?;
        sDescription.value =
            (data['originator'] as Map<String, dynamic>)['description']
                as String?;
        sQuoteUrl.value = data['url'] as String?;
      } else {
        sQuote.value = 'Failed to load quote';
        sAuthor.value = 'Failed to load author';
        sDescription.value = 'Failed to load description';
      }
    } on Exception catch (e) {
      sQuote.value = 'An error occurred';
      sAuthor.value = 'Please try again later';
      sDescription.value = 'Failed to load description';
      logger.e('Error fetching quote: $e');
    } finally {
      sLoading.value = false;
    }
  }
}
