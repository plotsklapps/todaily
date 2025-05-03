import 'dart:async';
import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
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

  File? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<MoodType> firstRowMoods = MoodType.values.sublist(0, 6);
    final List<MoodType> secondRowMoods = MoodType.values.sublist(6);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${now.day.value}${now.suffix.value} ${now.month.value} '
                  '${now.year.value}',
                ),
                Text(now.time.value),
              ],
            ),
            const SizedBox(height: 8),
            // Title Text Field
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "today's title",
                labelStyle: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),

            // Description Text Field
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              maxLength: 220,
              decoration: const InputDecoration(
                labelText: "today's description",
                labelStyle: TextStyle(fontSize: 14),
              ),
            ),

            // Mood Selection
            const Text("today's mood"),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:
                      firstRowMoods.map((MoodType mood) {
                        final bool isSelected = _selectedMood == mood;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedMood = mood;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration:
                                isSelected
                                    ? BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 2,
                                      ),
                                    )
                                    : null,
                            child: Text(
                              mood.emoji,
                              style: const TextStyle(fontSize: 30),
                            ),
                          ),
                        );
                      }).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:
                      secondRowMoods.map((MoodType mood) {
                        final bool isSelected = _selectedMood == mood;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedMood = mood;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration:
                                isSelected
                                    ? BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 2,
                                      ),
                                    )
                                    : null,
                            child: Text(
                              mood.emoji,
                              style: const TextStyle(fontSize: 30),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
            const Text("today's image"),

            // Image Selection
            if (_image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 160),
                  child: ColoredBox(
                    color: Colors.grey,
                    child: Image.file(_image!, fit: BoxFit.contain),
                  ),
                ),
              )
            else
              const SizedBox.shrink(),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                    },
                    child: const FaIcon(FontAwesomeIcons.fileImage),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                    },
                    child: const FaIcon(FontAwesomeIcons.camera),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// MoodType enum
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
