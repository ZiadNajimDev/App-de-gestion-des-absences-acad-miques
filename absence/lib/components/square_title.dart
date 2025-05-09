import 'package:flutter/material.dart';

class SquareTitle extends StatelessWidget {
  final String imagePath;
  const SquareTitle({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.asset(imagePath, height: 40),
    );
  }
}
