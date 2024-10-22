import 'package:flutter/material.dart';

class SizedIconButton extends StatelessWidget {
  final double width;
  final IconData icon;
  final VoidCallback onPressed;

  const SizedIconButton({
    required this.width,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
      ),
    );
  }
}
