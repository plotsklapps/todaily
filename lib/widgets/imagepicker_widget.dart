import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

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
  final Logger _logger = Logger();

  Future<void> _pickImage(int index) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null) {
        final Uint8List imageData = await pickedFile.readAsBytes();
        setState(() {
          _images[index] = imageData;
        });
      }
    } on Exception catch (error, stackTrace) {
      _logger.e('Error picking image: $error, $stackTrace');
    }
  }

  Future<void> _takePicture(int index) async {
    try {
      final List<CameraDescription> cameras = await availableCameras();

      // Check if there are cameras available
      if (cameras.isEmpty) {
        _logger.e('No cameras available');
        return;
      }

      // Allow the user to select a camera (default to the first one)
      final CameraDescription selectedCamera = cameras.firstWhere(
        (CameraDescription camera) {
          return camera.lensDirection == CameraLensDirection.front;
        },
        orElse: () {
          return cameras.first;
        },
      );

      final CameraController cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
      );

      await cameraController.initialize();

      // Show the CameraPreview in a ModalBottomSheet
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AspectRatio(
                aspectRatio: cameraController.value.aspectRatio,
                child: CameraPreview(cameraController),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the sheet
                          cameraController.dispose();
                        },
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          final XFile picture =
                              await cameraController.takePicture();
                          final Uint8List imageData =
                              await picture.readAsBytes();

                          setState(() {
                            _images[index] = imageData;
                          });

                          Navigator.pop(context); // Close the sheet
                          cameraController.dispose();
                        },
                        child: const Text('Capture'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    } on Exception catch (error, stackTrace) {
      _logger.e('Error taking picture: $error, $stackTrace');
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
              // Show options to pick from gallery or take a picture.
              showModalBottomSheet<Widget>(
                showDragHandle: true,
                context: context,
                builder: (BuildContext context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Select Image'),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: FilledButton(
                                onPressed: () {
                                  // Pop the bottomsheet.
                                  Navigator.pop(context);

                                  // Open the image picker.
                                  _pickImage(index);
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FaIcon(FontAwesomeIcons.fileImage),
                                    SizedBox(width: 8),
                                    Text('Gallery'),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: FilledButton(
                                onPressed: () {
                                  // Pop the bottomsheet.
                                  Navigator.pop(context);

                                  // Open the camera.
                                  _takePicture(index);
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FaIcon(FontAwesomeIcons.camera),
                                    SizedBox(width: 8),
                                    Text('Camera'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: Card(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 5,
              height: MediaQuery.of(context).size.width / 6,
              child:
                  _images[index] != null
                      ? Image.memory(_images[index]!, fit: BoxFit.cover)
                      : const Center(
                        child: FaIcon(
                          FontAwesomeIcons.plus,
                          color: Colors.grey,
                        ),
                      ),
            ),
          ),
        );
      }),
    );
  }
}
