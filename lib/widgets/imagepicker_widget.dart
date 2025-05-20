import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:signals/signals_flutter.dart';
import 'package:todaily/modals/changeimage_modal.dart';
import 'package:todaily/modals/pickimage_modal.dart';
import 'package:todaily/scrollconfiguration_logic.dart';
import 'package:todaily/state/journal_signal.dart';
import 'package:todaily/toast.dart';
import 'package:todaily/widgets/modal_logic.dart';

class ImagePickerCarousel extends StatefulWidget {
  const ImagePickerCarousel({required this.onImagePathsChanged, super.key});

  final ValueChanged<List<String>> onImagePathsChanged;

  @override
  State<ImagePickerCarousel> createState() {
    return _ImagePickerCarouselState();
  }
}

class _ImagePickerCarouselState extends State<ImagePickerCarousel> {
  final ImagePicker _picker = ImagePicker();
  final Logger _logger = Logger();

  Future<void> _pickImage(int index) async {
    try {
      // Pick image from gallery and set max width and height.
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null) {
        // Convert image to Uint8List (memory efficient).
        final Uint8List imageData = await pickedFile.readAsBytes();

        // Update the image in the list.
        sImages.value[index] = imageData;
      }
    } on Exception catch (error, stackTrace) {
      // Show the error to the user.
      showErrorToast(message: 'Error picking image: $error');

      // Log the error.
      _logger.e('Error picking image: $error, $stackTrace');
    }
  }

  Future<void> _takePicture(int index) async {
    try {
      // Get the available cameras.
      final List<CameraDescription> cameras = await availableCameras();

      if (cameras.isEmpty) {
        // Show error to the user.
        showErrorToast(message: 'No camera found!');

        // Log the error.
        _logger.e('No cameras available');
        return;
      }

      final CameraDescription selectedCamera = cameras.firstWhere(
        (CameraDescription camera) {
          // Look for the first front-facing camera available.
          return camera.lensDirection == CameraLensDirection.front;
        },
        orElse: () {
          // No front facing? Just return the first.
          return cameras.first;
        },
      );

      // Create a controller for the selected camera with medium resolution.
      final CameraController cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
      );

      // Initialize the controller.
      await cameraController.initialize();

      if (mounted) {
        await showModalBottomSheet<Widget>(
          showDragHandle: true,
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Show a preview of the camera.
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
                            // Pop the bottomsheet.
                            Navigator.pop(context);

                            // Dispose the controller.
                            cameraController.dispose();
                          },
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton(
                          onPressed: () async {
                            // Take a picture.
                            final XFile picture = await cameraController
                                .takePicture();

                            // Convert image to Uint8List (memory efficient).
                            final Uint8List imageData = await picture
                                .readAsBytes();

                            // Update the image in the list.
                            sImages.value[index] = imageData;

                            // Pop the bottomsheet.
                            Navigator.pop(context);

                            // Dispose the controller.
                            await cameraController.dispose();
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
      }
    } on Exception catch (error, stackTrace) {
      // Show the error to the user.
      showErrorToast(message: 'Error taking picture: $error');

      // Log the error.
      _logger.e('Error taking picture: $error, $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: CustomScrollConfiguration(
        child: CarouselView(
          itemExtent: 100,
          shrinkExtent: 80,
          onTap: (int index) {
            final Uint8List? imageIndex = sImages.watch(context)[index];
            if (imageIndex != null) {
              showModal(
                context: context,
                child: ChangeImageModal(
                  image: imageIndex,
                  index: index,
                  onRemove: () {
                    sImages.value[index] = null;
                  },
                  onChange: () {
                    _pickImage(index);
                  },
                ),
              );
            } else {
              showModal(
                context: context,
                child: PickImageModal(
                  index: index,
                  onPickImage: () {
                    _pickImage(index);
                  },
                  onTakePicture: () async {
                    await _takePicture(index);
                  },
                ),
              );
            }
          },
          children: List<Widget>.generate(12, (int index) {
            final Uint8List? imageIndex = sImages.watch(context)[index];
            return imageIndex != null
                ? Image.memory(imageIndex, fit: BoxFit.cover)
                : const Center(
                    child: FaIcon(FontAwesomeIcons.plus, color: Colors.grey),
                  );
          }),
        ),
      ),
    );
  }
}
