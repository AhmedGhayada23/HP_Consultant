import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

class PopoverItem extends StatelessWidget {
  final PopoverTransition transition;
  final Widget child;
  final BuildContext context;
  final Color backgroundColor;
  final PopoverDirection direction;
  final double radius;
  final List<BoxShadow> boxShadow;
  final Animation<double> animation;
  final double arrowWidth;
  final double arrowHeight;
  final BoxConstraints? constraints;
  final double arrowDxOffset;
  final double arrowDyOffset;
  final double contentDyOffset;
  final double contentDxOffset;
  final Rect? position; // ✅ ← تم إضافته هنا

  const PopoverItem({
    super.key,
    required this.transition,
    required this.child,
    required this.context,
    required this.backgroundColor,
    required this.direction,
    required this.radius,
    required this.boxShadow,
    required this.animation,
    required this.arrowWidth,
    required this.arrowHeight,
    required this.constraints,
    required this.arrowDxOffset,
    required this.arrowDyOffset,
    required this.contentDyOffset,
    required this.contentDxOffset,
    this.position, // ✅ ← تم إضافته هنا
  });

  @override
  Widget build(BuildContext context) {
    // ✅ حساب موضع العنصر الهدف (الزر) الذي سيظهر فوقه أو تحته الـ Popover
    final Rect targetRect = position ?? _calculateTargetRect();

    // ملاحظة: هنا بإمكانك استخدام targetRect لتحديد مكان الـ Popover بدقة.

    return Stack(
      children: [
        Positioned(
          top: _calculatePopoverTop(targetRect),
          left: _calculatePopoverLeft(targetRect),
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: constraints,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(radius),
                boxShadow: boxShadow,
              ),
              child: child,
            ),
          ),
        ),
      ],
    );
  }

  // ✅ إذا لم يتم تمرير position، نستخدم هذه الدالة لحسابه من context
  Rect _calculateTargetRect() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    return Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
  }

  // 🔧 دالة لحساب الموضع العلوي للـ Popover
  double _calculatePopoverTop(Rect rect) {
    switch (direction) {
      case PopoverDirection.bottom:
        return rect.bottom + arrowHeight + contentDyOffset;
      case PopoverDirection.top:
        return rect.top - (constraints?.maxHeight ?? 0) - arrowHeight + contentDyOffset;
      default:
        return rect.bottom + contentDyOffset;
    }
  }

  // 🔧 دالة لحساب الموضع الأفقي للـ Popover
  double _calculatePopoverLeft(Rect rect) {
    return rect.left + contentDxOffset;
  }
}
