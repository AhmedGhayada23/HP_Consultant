import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircleIcon extends StatelessWidget {
  const CircleIcon({super.key, required this.icon});

  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 148.w,
      height: 148.h,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 148.w,
              height: 148.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.grey.shade200, Colors.white],
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: Container(
              width: 116.w,
              height: 116.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade200),
              ),
            ),
          ),
          Center(child: icon),
        ],
      ),
    );
  }
}
