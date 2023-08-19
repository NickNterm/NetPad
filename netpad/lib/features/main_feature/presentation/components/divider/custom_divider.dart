import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.cyan.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
