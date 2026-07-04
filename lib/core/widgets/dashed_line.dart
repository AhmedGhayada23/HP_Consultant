import 'package:flutter/material.dart';

class DashedLine extends StatelessWidget {
  final int dashCount;
  final TextStyle? dashStyle;
  final Color? color;

  const DashedLine({
    super.key,
    this.dashCount = 20,
    this.dashStyle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        dashCount,
        (index) => Expanded(
          child: Text(
            'ـــ',
            textAlign: TextAlign.center,
            style: dashStyle ??
                TextStyle(
                  color: color ?? Colors.grey,
                  fontSize: 14,
                ),
          ),
        ),
      ),
    );
  }
}
