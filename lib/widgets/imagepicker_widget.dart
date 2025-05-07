import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:todaily/theme/flex_theme.dart';

class ImagePickerRow extends StatefulWidget {
  const ImagePickerRow({super.key});

  @override
  State<ImagePickerRow> createState() {
    return _ImagePickerGridState();
  }
}

class _ImagePickerGridState extends State<ImagePickerRow> {
  // List of images in Uint8List format. Nullable to allow for empty slots.
  final List<Uint8List?> _images = List<Uint8List?>.filled(4, null);

  // ImagePicker instance from the image_picker package.
  final ImagePicker _picker = ImagePicker();

  // Logger instance for logging information.
  final Logger _logger = Logger();

  Future<void> _pickImage(int index) async {
    try {
      // Use the ImagePicker to select an image from the gallery or camera.
      // If index is 3, use the camera; otherwise, use the gallery.
      final XFile? pickedFile = await _picker.pickImage(
        source: index == 3 ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null) {
        // Read the selected image as bytes and store it in the _images list.
        final Uint8List imageData = await pickedFile.readAsBytes();
        setState(() {
          _images[index] = imageData;
        });
      }
    } on Exception catch (error, stackTrace) {
      // Log any errors that occur during image picking.
      _logger.e('Error picking image: $error, $stackTrace');
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
              // Open bottomsheet to view and change or remove the image.
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
                          children: <Widget>[
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  // Pop the bottomsheet.
                                  Navigator.pop(context);

                                  // Remove the image from the list.
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
                                  // Pop the bottomsheet.
                                  Navigator.pop(context);

                                  // Pick a new image.
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
              // No image is selected, pick a new image.
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
