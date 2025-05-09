import 'dart:typed_data';

import 'package:flutter/material.dart';

class ChangeImageModal extends StatelessWidget {
  const ChangeImageModal({
    required this.image,
    required this.index,
    required this.onRemove,
    required this.onChange,
    super.key,
  });

  final Uint8List image;
  final int index;
  final VoidCallback onRemove;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(child: Image.memory(image, fit: BoxFit.contain)),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onRemove();
                  },
                  child: const Text('Remove Image'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onChange();
                  },
                  child: const Text('Change Image'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
