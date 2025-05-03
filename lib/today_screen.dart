import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals/signals_flutter.dart';
import 'package:todaily/image_signal.dart';
import 'package:todaily/now_signal.dart';

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
  MoodType _selectedMood = MoodType.neutral;
  final PickImage _pickImage = PickImage();

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
            MoodSelection(
              selectedMood: _selectedMood,
              onMoodSelected: (MoodType mood) {
                setState(() {
                  _selectedMood = mood;
                });
              },
            ),
            const Text("today's image"),
            ImagePreview(image: _pickImage.image.watch(context)),
            const SizedBox(height: 16),
            ImagePickerButtons(onPickImage: _pickImage.pickImage),
            const SizedBox(height: 16),
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
    final List<MoodType> firstRowMoods = MoodType.values.sublist(0, 6);
    final List<MoodType> secondRowMoods = MoodType.values.sublist(6);

    return Column(
      children: <Widget>[
        MoodRow(
          moods: firstRowMoods,
          selectedMood: selectedMood,
          onMoodSelected: onMoodSelected,
        ),
        MoodRow(
          moods: secondRowMoods,
          selectedMood: selectedMood,
          onMoodSelected: onMoodSelected,
        ),
      ],
    );
  }
}

class MoodRow extends StatelessWidget {
  const MoodRow({
    required this.moods,
    required this.selectedMood,
    required this.onMoodSelected,
    super.key,
  });
  final List<MoodType> moods;
  final MoodType selectedMood;
  final ValueChanged<MoodType> onMoodSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:
          moods.map((MoodType mood) {
            final bool isSelected = selectedMood == mood;
            return InkWell(
              onTap: () => onMoodSelected(mood),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration:
                    isSelected
                        ? BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue, width: 2),
                        )
                        : null,
                child: Text(mood.emoji, style: const TextStyle(fontSize: 30)),
              ),
            );
          }).toList(),
    );
  }
}

class ImagePreview extends StatelessWidget {
  const ImagePreview({this.image, super.key});
  final Uint8List? image;

  @override
  Widget build(BuildContext context) {
    if (image == null) return const SizedBox.shrink();

    return FutureBuilder<ImageInfo>(
      future: _getImageInfo(image!),
      builder: (BuildContext context, AsyncSnapshot<ImageInfo> snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final ImageInfo imageInfo = snapshot.data!;
        final bool isPortrait = imageInfo.image.height > imageInfo.image.width;

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: isPortrait ? 300 : 160,
              maxWidth: isPortrait ? 160 : 300,
            ),
            child: ColoredBox(
              color: Colors.grey,
              child: Image.memory(image!, fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }

  Future<ImageInfo> _getImageInfo(Uint8List imageData) async {
    final Completer<ImageInfo> completer = Completer<ImageInfo>();
    final Image image = Image.memory(imageData);
    image.image
        .resolve(ImageConfiguration.empty)
        .addListener(
          ImageStreamListener((ImageInfo info, _) {
            completer.complete(info);
          }),
        );
    return completer.future;
  }
}

class ImagePickerButtons extends StatelessWidget {
  const ImagePickerButtons({required this.onPickImage, super.key});
  final VoidCallback onPickImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: ElevatedButton(
            onPressed: onPickImage,
            child: const FaIcon(FontAwesomeIcons.fileImage),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            child: const FaIcon(FontAwesomeIcons.camera),
          ),
        ),
      ],
    );
  }
}

enum MoodType {
  angry('😠'),
  sad('😢'),
  neutral('😐'),
  relaxed('😌'),
  happy('😄'),
  excited('🤩'),
  confused('😕'),
  surprised('😲'),
  sick('🤢'),
  sleepy('😴'),
  loving('😍'),
  worried('😟');

  const MoodType(this.emoji);

  final String emoji;
}
