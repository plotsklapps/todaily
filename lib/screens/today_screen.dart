import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todaily/now_signal.dart';
import 'package:todaily/theme/flex_theme.dart';

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
            const ImagePickerRow(),
            const SizedBox(height: 16),
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

class ImagePickerRow extends StatefulWidget {
  const ImagePickerRow({super.key});

  @override
  State<ImagePickerRow> createState() {
    return _ImagePickerGridState();
  }
}

class _ImagePickerGridState extends State<ImagePickerRow> {
  final List<Uint8List?> _images = List<Uint8List?>.filled(4, null);
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(int index) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: index == 3 ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 800, // Optional: Resize the image
        maxHeight: 800,
      );

      if (pickedFile != null) {
        final Uint8List imageData = await pickedFile.readAsBytes();
        setState(() {
          _images[index] = imageData;
        });
      }
    } on Exception catch (e) {
      // Handle errors (e.g., user cancels the picker)
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List<Widget>.generate(4, (int index) {
        return GestureDetector(
          onTap: () {
            if (index == 3 ||
                _images.where((Uint8List? image) => image != null).length < 4) {
              _pickImage(index);
            }
          },
          child: Card(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 5,
              height: MediaQuery.of(context).size.width / 6,
              child:
                  _images[index] != null
                      ? Image.memory(_images[index]!, fit: BoxFit.cover)
                      : Center(
                        child: FaIcon(
                          index == 3
                              ? FontAwesomeIcons
                                  .camera // Camera icon for the fourth card
                              : FontAwesomeIcons.fileCirclePlus,
                          color: cThemeData.value.colorScheme.primary,
                        ),
                      ),
            ),
          ),
        );
      }),
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
