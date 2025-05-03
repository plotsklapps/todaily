import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:signals/signals_flutter.dart';

class PickImage {
  // Nullable Signal of type Uint8List to hold the image data.
  final Signal<Uint8List?> image = Signal<Uint8List?>(
    null,
    debugLabel: 'image',
  );

  Future<void> pickImage() async {
    // Create an instance of ImagePicker.
    final ImagePicker picker = ImagePicker();

    // Open the device's gallery and allow the user to pick an image. Store
    // the picked file as an XFile object or null.
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    // Check if the user picked a file.
    if (pickedFile != null) {
      // Read the file as a byte array and store it as a Uint8List object.
      final Uint8List imageData = await pickedFile.readAsBytes();

      // Update the Signal with the new image data.
      image.value = imageData;
    }
  }
}
