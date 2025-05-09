import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:todaily/modals/changeimage_modal.dart';
import 'package:todaily/modals/pickimage_modal.dart';
import 'package:todaily/widgets/modal_widget.dart';

class ImagePickerCarousel extends StatefulWidget {
  const ImagePickerCarousel({super.key});

  @override
  State<ImagePickerCarousel> createState() {
    return _ImagePickerCarouselState();
  }
}

class _ImagePickerCarouselState extends State<ImagePickerCarousel> {
  final List<Uint8List?> _images = List<Uint8List?>.filled(12, null);
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

      if (cameras.isEmpty) {
        _logger.e('No cameras available');
        return;
      }

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

      if (mounted) {
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
                            Navigator.pop(context);
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

                            Navigator.pop(context);
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
      }
    } on Exception catch (error, stackTrace) {
      _logger.e('Error taking picture: $error, $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          overscroll: false,
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
            if (_images[index] != null) {
              showModal(
                context: context,
                child: ChangeImageModal(
                  image: _images[index]!,
                  index: index,
                  onRemove: () {
                    setState(() {
                      _images[index] = null;
                    });
                  },
                  onChange: () {
                    _pickImage(index);
                  },
                ),
              );
            } else {
              showModalBottomSheet<Widget>(
                showDragHandle: true,
                context: context,
                builder: (BuildContext context) {
                  return PickImageModal(
                    index: index,
                    onPickImage: () => _pickImage(index),
                    onTakePicture: () => _takePicture(index),
                  );
                },
              );
            }
          },
          children: List<Widget>.generate(12, (int index) {
            return _images[index] != null
                ? Image.memory(_images[index]!, fit: BoxFit.cover)
                : const Center(
                  child: FaIcon(FontAwesomeIcons.plus, color: Colors.grey),
                );
          }),
        ),
      ),
    );
  }
}
