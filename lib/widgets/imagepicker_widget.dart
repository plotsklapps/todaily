import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signals/signals_flutter.dart';
import 'package:todaily/logic/pickimage_service.dart';
import 'package:todaily/modals/changeimage_modal.dart';
import 'package:todaily/modals/pickimage_modal.dart';
import 'package:todaily/scrollconfiguration_logic.dart';
import 'package:todaily/widgets/modal_logic.dart';

// A horizontal carousel for selecting and displaying images.
// This widget allows users to select images from their gallery or take
// pictures using the camera. It displays the selected images in a
// horizontally scrolling carousel.
class ImagePickerCarousel extends StatefulWidget {
  const ImagePickerCarousel({required this.onImagePathsChanged, super.key});

  // Callback function triggered when the list of image paths changes.
  final ValueChanged<List<String>> onImagePathsChanged;

  @override
  State<ImagePickerCarousel> createState() {
    return _ImagePickerCarouselState();
  }
}

class _ImagePickerCarouselState extends State<ImagePickerCarousel> {
  // Service for handling image picking and taking logic.
  late final PickImageService _pickImageService;

  // Signal to hold the list of selected images.
  final Signal<List<Uint8List?>> sImagesList = Signal<List<Uint8List?>>(
    List<Uint8List?>.generate(12, (int index) => null),
  );

  @override
  void initState() {
    super.initState();
    _pickImageService = PickImageService();
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
            // Get the image at the tapped index.
            final Uint8List? imageIndex = sImagesList.watch(context)[index];
            if (imageIndex != null) {
              // If an image exists, show the modal to change/remove the image.
              showModal(
                context: context,
                child: ChangeImageModal(
                  image: imageIndex,
                  index: index,

                  // Callback for removing the image at the current index.
                  onRemove: () {
                    _pickImageService.updateImageAtIndex(
                      imageList: sImagesList,
                      index: index,
                      image: null,
                      onImagePathsChanged: widget.onImagePathsChanged,
                    );
                  },

                  // Callback for changing the image at the current index.
                  onChange: () {
                    _pickImageService.pickImage(
                      context: context,
                      imageList: sImagesList,
                      index: index,
                      onImagePathsChanged: widget.onImagePathsChanged,
                    );
                  },
                ),
              );
            } else {
              // If no image exists, show the modal to pick an image or take
              // a picture.
              showModal(
                context: context,
                child: PickImageModal(
                  index: index,

                  // Callback for picking an image from the gallery.
                  onPickImage: () {
                    _pickImageService.pickImage(
                      context: context,
                      imageList: sImagesList,
                      index: index,
                      onImagePathsChanged: widget.onImagePathsChanged,
                    );
                  },

                  // Callback for taking a picture with the camera.
                  onTakePicture: () async {
                    await _pickImageService.takePicture(
                      context: context,
                      imageList: sImagesList,
                      index: index,
                      onImagePathsChanged: widget.onImagePathsChanged,
                    );
                  },
                ),
              );
            }
            // Notify the parent widget that the image paths have changed.
            // This forces the Signal to update the UI.
            widget.onImagePathsChanged(
              sImagesList.value.whereType<Uint8List>().map((_) {
                return 'image';
              }).toList(),
            );
          },

          // Generate 12 widgets for the carousel from the Signal.
          children: List<Widget>.generate(12, (int index) {
            final Uint8List? imageIndex = sImagesList.watch(context)[index];
            return imageIndex != null
                ?
                  // Display an image if available.
                  Image.memory(imageIndex, fit: BoxFit.cover)
                : const Center(
                    // Display an icon if not available.
                    child: FaIcon(FontAwesomeIcons.plus, color: Colors.grey),
                  );
          }),
        ),
      ),
    );
  }
}
