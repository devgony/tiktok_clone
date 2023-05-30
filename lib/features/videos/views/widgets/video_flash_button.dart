import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class VideoFlashButton extends StatelessWidget {
  final FlashMode flashMode;
  final FlashMode targetMode;
  final Function setFlashMode;
  final IconData icon;

  const VideoFlashButton({
    super.key,
    required this.flashMode,
    required this.targetMode,
    required this.setFlashMode,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: flashMode == targetMode ? Colors.amber.shade200 : Colors.white,
      onPressed: () => setFlashMode(targetMode),
      icon: Icon(icon),
    );
  }
}
