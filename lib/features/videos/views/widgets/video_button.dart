import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class VideoButton extends StatelessWidget {
  final IconData icon;
  final String? text;
  final Color? color;

  const VideoButton({
    super.key,
    required this.icon,
    this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FaIcon(
          icon,
          color: color ?? Colors.white,
          size: Sizes.size40,
        ),
        Gaps.v5,
        text != null
            ? Text(
                text!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Container(),
      ],
    );
  }
}
