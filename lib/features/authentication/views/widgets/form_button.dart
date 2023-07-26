import 'package:flutter/material.dart';

import '../../../../constants/sizes.dart';
import '../../../../utils.dart';

class FormButton extends StatelessWidget {
  final bool disabled;
  final String payload;

  const FormButton({
    super.key,
    required this.disabled,
    required this.payload,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.size16,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.size5),
          color: disabled
              ? isDarkMode(context)
                  ? Colors.grey.shade800
                  : Colors.grey.shade300
              : Theme.of(context).primaryColor,
        ),
        duration: const Duration(milliseconds: 500),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 500),
          style: TextStyle(
            color: disabled ? Colors.grey.shade400 : Colors.white,
            fontWeight: FontWeight.w600,
          ),
          child: Text(
            payload,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
