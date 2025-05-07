import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todaily/theme/flex_theme.dart';

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
        maxWidth: 800,
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
            if (_images[index] != null) {
              // Open modal bottom sheet to view and change the image
              showModalBottomSheet<Widget>(
                showDragHandle: true,
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: Image.memory(
                          _images[index]!,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    _images[index] = null;
                                  });
                                },
                                child: const Text('Remove Image'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: FilledButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _pickImage(index);
                                },
                                child: const Text('Change Image'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              // Allow picking a new image
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
                              ? FontAwesomeIcons.camera
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
