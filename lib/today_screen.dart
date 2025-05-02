import 'dart:async';
import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() {
    return _TodayScreenState();
  }
}

class _TodayScreenState extends State<TodayScreen> {
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
    final DateTime now = DateTime.now();
    final String day = DateFormat('d').format(now);
    final String suffix = _getSuffix(int.parse(day));
    final String month = DateFormat('MMMM').format(now);
    final String year = DateFormat('yyyy').format(now);
    final String time = DateFormat('HH:mm').format(now);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text('$day$suffix $month $year'), Text(time)],
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
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.spaceAround,
              children:
                  MoodType.values.map((MoodType mood) {
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

  String _getSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
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
