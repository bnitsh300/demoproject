import 'package:flutter/material.dart';
import 'package:my_task_flutter/widgets/colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: primarycolor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        shadows: [
          Shadow(
            offset: Offset(2, 2),
            blurRadius: 4.0,
            color: Colors.black.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}
