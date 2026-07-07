import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/local_storage.dart';
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_photo.dart';

/// شاشة البداية (Splash) — تصميم احترافي بأنيميشن خفيف ثم الانتقال حسب حالة الدخول
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  // دخول الشعار: تلاشٍ + تكبير خفيف
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..forward();
  late final Animation<double> _fade = CurvedAnimation(
    parent: _entrance,
    curve: Curves.easeOut,
  );
  late final Animation<double> _scale = Tween<double>(
    begin: 0.85,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _entrance, curve: Curves.easeOutBack));

  // حلقات النبض + شريط التقدّم
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat();

  @override
  void initState() {
    super.initState();
    _goNext();
  }

  @override
  void dispose() {
    _entrance.dispose();
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(milliseconds: 2600));
    if (!mounted) return;
    final token = LocalStorage().readValue<String>(Constants.token);
    final next = (token != null && token.isNotEmpty)
        ? MyRoutes().userView
        : MyRoutes().authSiginIn;
    Navigator.of(context).pushReplacementNamed(next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // خلفية متدرّجة ناعمة (قريبة من الأبيض لتفادي أي وميض مع الـ native splash)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff000C21), Color(0xff162A45)],
          ),
        ),
        child: Stack(
          children: [
            // الشعار في منتصف الشاشة تماماً
            Center(
              child: SizedBox(
                width: 240.r,
                height: 240.r,
                child: AnimatedBuilder(
                  animation: _pulse,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        _ring(0.0),
                        _ring(0.4),
                        // توهّج دائري خلف الشعار
                        Container(
                          width: 170.r,
                          height: 170.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColor.k1primeryColor.withValues(alpha: 0.14),
                                AppColor.k1primeryColor.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                        child!,
                      ],
                    );
                  },
                  child: FadeTransition(
                    opacity: _fade,
                    child: ScaleTransition(
                      scale: _scale,
                      child: Container(
                        width: 140.r,
                        height: 140.r,
                        padding: EdgeInsets.all(24.r),
                        decoration: BoxDecoration(
                          color: Color(0xff08162F),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.blackColor.withValues(
                                alpha: 0.08,
                              ),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          AppImage.logoImage,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // شريط التحميل مثبّت أسفل الشاشة
            Positioned(
              left: 0,
              right: 0,
              bottom: 48.h,
              child: Center(child: _loadingBar()),
            ),
          ],
        ),
      ),
    );
  }

  // حلقة تتمدّد وتتلاشى (نبض) خلف الشعار
  Widget _ring(double offset) {
    final t = (_pulse.value + offset) % 1.0;
    final size = 150.r + 90.r * t;
    return Opacity(
      opacity: (1 - t) * 0.30,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColor.k1primeryColor, width: 1.5),
        ),
      ),
    );
  }

  // شريط تقدّم غير محدّد: قطعة مضيئة تتحرّك داخل مسار مستدير
  Widget _loadingBar() {
    final trackWidth = 150.w;
    final segWidth = 55.w;
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: Container(
        width: trackWidth,
        height: 4.h,
        color: AppColor.k1primeryColor.withValues(alpha: 0.15),
        child: AnimatedBuilder(
          animation: _pulse,
          builder: (context, _) {
            final start = (trackWidth + segWidth) * _pulse.value - segWidth;
            return Stack(
              children: [
                Positioned(
                  left: start,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: segWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      gradient: LinearGradient(
                        colors: [
                          AppColor.k1primeryColor.withValues(alpha: 0.0),
                          AppColor.k1primeryColor,
                          AppColor.k1primeryColor.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
