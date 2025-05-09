import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:url_launcher/link.dart';

class QuoteWidget extends StatefulWidget {
  const QuoteWidget({super.key});

  @override
  State<QuoteWidget> createState() => _QuoteWidgetState();
}

class _QuoteWidgetState extends State<QuoteWidget> {
  String? quote;
  String? author;
  String? description;
  String? quoteUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  Future<void> fetchQuote() async {
    const String url =
        'https://quotes15.p.rapidapi.com/quotes/random/?language_code=en';
    const Map<String, String> headers = {
      'x-rapidapi-key': '4e9b09616amshcb8bc4ff62ef298p15f8d8jsn8527db553cab',
      'x-rapidapi-host': 'quotes15.p.rapidapi.com',
    };

    try {
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        Logger().i(response.body);
        final Map<String, dynamic> data =
            json.decode(response.body) as Map<String, dynamic>;
        setState(() {
          quote = data['content'] as String?;
          author = data['originator']['name'] as String?;
          description = data['originator']['description'] as String?;
          quoteUrl = data['url'] as String?;
          isLoading = false;
        });
      } else {
        setState(() {
          quote = 'Failed to load quote';
          author = '';
          description = '';
          isLoading = false;
        });
      }
    } on Exception catch (e) {
      setState(() {
        quote = 'An error occurred';
        author = '';
        description = '';
        isLoading = false;
      });
      Logger().e('Error fetching quote: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
          children: <Widget>[
            Text(
              '"${quote ?? 'No quote available'}"',
              style: const TextStyle(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () {
                showModalBottomSheet<Widget>(
                  showDragHandle: true,
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return ScrollConfiguration(
                      behavior: const ScrollBehavior().copyWith(
                        scrollbars: false,
                        physics: const BouncingScrollPhysics(),
                        dragDevices: <PointerDeviceKind>{
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                          PointerDeviceKind.stylus,
                          PointerDeviceKind.trackpad,
                        },
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header section
                          Text(
                            'Quote by ${author ?? 'Unknown'}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const Divider(),

                          // Scrollable content
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    (description?.isEmpty ?? true)
                                        ? 'No originator description '
                                            'available, but you can visit the '
                                            'source to find out more.'
                                        : description!,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Divider(),
                          const SizedBox(height: 8),
                          // Footer section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
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
                                    uri: Uri.parse(quoteUrl ?? ''),
                                    target: LinkTarget.blank,
                                    builder: (
                                      BuildContext context,
                                      FollowLink? followLink,
                                    ) {
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
                      ),
                    );
                  },
                );
              },
              child: Text('- ${author ?? 'Unknown'}'),
            ),
          ],
        );
  }
}
