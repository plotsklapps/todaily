import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signals/signals_flutter.dart';
import 'package:todaily/widgets/modal_logic.dart';

// Service class responsible for handling image picking and taking logic.
class PickImageService {
  // Allows the user to open the device's gallery and pick an image.
  Future<void> pickImage({
    required BuildContext context,
    required Signal<List<Uint8List?>> imageList,
    required int index,
    required ValueChanged<List<String>> onImagePathsChanged,
  }) async {
    // Use 'image_picker' package to open the gallery and select an image.
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      // Convert image to Uint8List (memory efficient).
      final Uint8List imageData = await pickedFile.readAsBytes();

      // Update the image list using the dedicated method.
      updateImageAtIndex(
        imageList: imageList,
        index: index,
        image: imageData,
        onImagePathsChanged: onImagePathsChanged,
      );
    }
  }

  // Allows the user to take a picture using the device's camera.
  Future<void> takePicture({
    required BuildContext context,
    required Signal<List<Uint8List?>> imageList,
    required int index,
    required ValueChanged<List<String>> onImagePathsChanged,
  }) async {
    // Use 'camera' package to open the camera and take a picture.
    final List<CameraDescription> cameras = await availableCameras();

    // Create a controller for the camera.
    final CameraController cameraController = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      // Initialize the cameraController.
      await cameraController.initialize();
      if (!context.mounted) {
        return;
      }
      await showModal(
        context: context,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (cameraController.value.isInitialized)
              CameraPreview(cameraController)
            else
              const CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: () async {
                  // Take a picture.
                  final XFile picture = await cameraController.takePicture();

                  // Convert image to Uint8List (memory efficient).
                  final Uint8List imageData = await picture.readAsBytes();

                  // Update the image list using the dedicated method.
                  updateImageAtIndex(
                    onImagePathsChanged: onImagePathsChanged,
                    imageList: imageList,
                    index: index,
                    image: imageData,
                  );

                  // Pop the modal.
                  if (context.mounted) {
                    Navigator.pop(context);
                  }

                  // Dispose the controller.
                  await cameraController.dispose();
                },
                child: const Text('Capture'),
              ),
            ),
          ],
        ),
      );
    } on Exception catch (e) {
      debugPrint('Error initializing camera: $e');
      // Handle error
    }
  }

  // Updates the image data at a specific index within the image list Signal.
  void updateImageAtIndex({
    required Signal<List<Uint8List?>> imageList,
    required int index,
    required Uint8List? image,
    required ValueChanged<List<String>> onImagePathsChanged,
  }) {
    // Copy the imageList.
    final List<Uint8List?> updatedImages = List<Uint8List?>.from(
      imageList.value,
    );

    // Update the imageList with the new image at the specified index.
    updatedImages[index] = image;

    // Update the Signal, triggering a UI update where watched.
    imageList.value = updatedImages;

    // Generate the list of placeholder image paths and call the callback.
    onImagePathsChanged(
      imageList.value.map((Uint8List? image) {
        return image != null ? 'image' : '';
      }).toList(),
    );
  }
}
