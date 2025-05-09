import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todaily/state/now_signal.dart';
import 'package:todaily/widgets/imagepicker_widget.dart';
import 'package:todaily/widgets/quote_widget.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() {
    return _TodayScreenState();
  }
}

class _TodayScreenState extends State<TodayScreen> {
  final Now now = Now();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  MoodType _selectedMood = MoodType.relaxed;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const QuoteWidget(),
            DateTimeRow(now: now),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _titleController,
              label: "today's title",
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _descriptionController,
              label: "today's description",
              maxLines: 5,
              maxLength: 220,
            ),
            const Text("today's mood"),
            const SizedBox(height: 8),
            MoodSelection(
              selectedMood: _selectedMood,
              onMoodSelected: (MoodType mood) {
                setState(() {
                  _selectedMood = mood;
                });
              },
            ),
            const SizedBox(height: 8),
            const Text("today's images"),
            const SizedBox(height: 8),
            const ImagePickerCarousel(),
          ],
        ),
      ),
    );
  }
}

class DateTimeRow extends StatelessWidget {
  const DateTimeRow({required this.now, super.key});
  final Now now;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '${now.day.value}${now.suffix.value} ${now.month.value} '
          '${now.year.value}',
        ),
        Text(now.time.value),
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.controller,
    required this.label,
    this.maxLines = 1,
    this.maxLength,
    super.key,
  });
  final TextEditingController controller;
  final String label;
  final int maxLines;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 14),
      ),
    );
  }
}

class MoodSelection extends StatelessWidget {
  const MoodSelection({
    required this.selectedMood,
    required this.onMoodSelected,
    super.key,
  });

  final MoodType selectedMood;
  final ValueChanged<MoodType> onMoodSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ScrollConfiguration(
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
        child: CarouselView(
          itemExtent: 100,
          shrinkExtent: 80,
          itemSnapping: true,
          onTap: (int index) {
            onMoodSelected(MoodType.values[index]);
          },
          children:
              MoodType.values.map((MoodType mood) {
                final bool isSelected = selectedMood == mood;

                return Center(
                  child: FaIcon(
                    mood.icon,
                    color:
                        isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}

enum MoodType {
  angry(FontAwesomeIcons.faceAngry),
  sad(FontAwesomeIcons.faceSadTear),
  neutral(FontAwesomeIcons.faceMeh),
  relaxed(FontAwesomeIcons.faceSmile),
  happy(FontAwesomeIcons.faceGrin),
  excited(FontAwesomeIcons.faceGrinStars),
  confused(FontAwesomeIcons.faceFlushed),
  surprised(FontAwesomeIcons.faceSurprise),
  sick(FontAwesomeIcons.faceDizzy),
  sleepy(FontAwesomeIcons.faceTired),
  loving(FontAwesomeIcons.faceKiss),
  worried(FontAwesomeIcons.faceFrownOpen);

  const MoodType(this.icon);

  final IconData icon;
}
