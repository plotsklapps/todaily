import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

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
  MoodType _selectedMood = MoodType.relaxed;
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

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FaIcon(
                      mood.icon,
                      color:
                          isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      mood.name,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color:
                            isSelected
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
