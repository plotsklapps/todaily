import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signals/signals_flutter.dart';
import 'package:todaily/scrollconfiguration_logic.dart';

// Signal for the current font family. Defaults to Questrial.
final Signal<String> sFont = Signal<String>(
  GoogleFonts.questrial().fontFamily!,
  debugLabel: 'sFont',
);

// CarouselView widget to display a list of fonts.
class ThemeFontCarousel extends StatelessWidget {
  const ThemeFontCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> fontNames = <String>[
      GoogleFonts.roboto().fontFamily!,
      GoogleFonts.openSans().fontFamily!,
      GoogleFonts.lato().fontFamily!,
      GoogleFonts.montserrat().fontFamily!,
      GoogleFonts.poppins().fontFamily!,
      GoogleFonts.raleway().fontFamily!,
      GoogleFonts.notoSans().fontFamily!,
      GoogleFonts.teko().fontFamily!,
      GoogleFonts.merriweather().fontFamily!,
      GoogleFonts.inter().fontFamily!,
      GoogleFonts.ptSans().fontFamily!,
      GoogleFonts.sourceSans3().fontFamily!,
      GoogleFonts.nunito().fontFamily!,
      GoogleFonts.playfairDisplay().fontFamily!,
      GoogleFonts.quicksand().fontFamily!,
      GoogleFonts.workSans().fontFamily!,
      GoogleFonts.cabin().fontFamily!,
      GoogleFonts.ubuntu().fontFamily!,
      GoogleFonts.dancingScript().fontFamily!,
      GoogleFonts.firaSans().fontFamily!,
      GoogleFonts.josefinSans().fontFamily!,
      GoogleFonts.mulish().fontFamily!,
      GoogleFonts.barlow().fontFamily!,
      GoogleFonts.inconsolata().fontFamily!,
      GoogleFonts.lora().fontFamily!,
      GoogleFonts.titilliumWeb().fontFamily!,
      GoogleFonts.varelaRound().fontFamily!,
      GoogleFonts.zillaSlab().fontFamily!,
      GoogleFonts.questrial().fontFamily!,
      GoogleFonts.manrope().fontFamily!,
    ];

    return SizedBox(
      height: 110,
      child: CustomScrollConfiguration(
        child: CarouselView(
          itemExtent: 100,
          shrinkExtent: 60,
          itemSnapping: true,
          onTap: (int index) {
            sFont.value = fontNames[index];
          },
          children: fontNames.map((String fontName) {
            final bool isSelected = sFont.watch(context) == fontName;
            final String baseFontName = fontName.split('_')[0];

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Lorem ipsum dolor sit amet...',
                  style: TextStyle(
                    fontFamily: fontName,
                    fontSize: 16,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                Text(
                  baseFontName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
