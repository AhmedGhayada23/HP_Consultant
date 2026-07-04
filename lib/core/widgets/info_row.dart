import 'package:flutter/material.dart';
import 'package:hb/core/styles/app_font.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: MyTextStyle().textStyleMedium14()),
        Flexible(
          child: Text(
            value,
            style: valueColor != null
                ? MyTextStyle().textStyleMedium15().copyWith(color: valueColor)
                : MyTextStyle().textStyleMedium15(),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
