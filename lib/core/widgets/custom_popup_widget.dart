import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/dashed_line.dart';

class CustomPopupWidget extends StatelessWidget {
  final Widget child;
  final List<PopupMenuItemModel> items;

  const CustomPopupWidget({super.key, required this.child, required this.items});

  void _showCustomMenu(BuildContext context) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);
    final Size buttonSize = button.size;

    final Size screenSize = MediaQuery.of(context).size;

    // حساب المسافة من الجوانب (left, right) لتجنب خروج الـ popup من الشاشة
    double left = buttonPosition.dx + buttonSize.width / 2 - 100; // 100 = نصف عرض الـ popup (200/2)
    if (left < 8) {
      left = 8; // مسافة من اليسار لمنع الاقتراب الشديد من الحافة
    } else if (left + 200 + 8 > screenSize.width) {
      left = screenSize.width - 200 - 8; // يمنع خروج الـ popup من اليمين
    }

    final double top = buttonPosition.dy + buttonSize.height - 50; // أسفل الأيقونة + مساحة السهم

    showDialog(
      context: context,
      barrierColor: Colors.transparent, // خلفية شفافة
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(color: Colors.transparent),
            ),
            Positioned(
              left: left,
              top: top,
              child: _PopupContent(items: items),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () => _showCustomMenu(context), child: child);
  }
}

class PopupMenuItemModel {
  final String text;
  final VoidCallback onTap;
  final Color? color;

  PopupMenuItemModel({required this.text, required this.onTap, this.color});
}

class _PopupContent extends StatelessWidget {
  final List<PopupMenuItemModel> items;
  final Color? textColor;
  const _PopupContent({super.key, required this.items, this.textColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 10,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // السهم الصغير فوق البوب أب
          CustomPaint(painter: _TrianglePainter(), child: SizedBox(height: 8, width: 20)),
          Container(
            width: 200.w,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  items[index].onTap();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    items[index].text,
                    style: MyTextStyle().textStyleMedium14().copyWith(
                      color: items[index].color ?? textColor,
                    ),
                  ),
                ),
              ),
              separatorBuilder: (context, index) => DashedLine(dashCount: 6),
              itemCount: items.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Colors.white;
    final Path path = Path();

    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black.withOpacity(0.7), 3, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
