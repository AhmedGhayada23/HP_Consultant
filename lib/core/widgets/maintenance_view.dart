import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/local_storage.dart';
import 'package:hb/core/navigation/app_navigator.dart';
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/maintenance_service.dart';
import 'package:hb/l10n/app_localizations.dart';

/// شاشة صيانة احترافية تظهر عند أخطاء السيرفر (500 فما فوق)
class MaintenanceView extends StatefulWidget {
  const MaintenanceView({super.key});

  @override
  State<MaintenanceView> createState() => _MaintenanceViewState();
}

class _MaintenanceViewState extends State<MaintenanceView>
    with TickerProviderStateMixin {
  late final AnimationController _spin; // دوران الترس
  late final AnimationController _pulse; // حلقات نابضة

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _spin.dispose();
    _pulse.dispose();
    super.dispose();
  }

  void _retry() {
    MaintenanceService.instance.reset();
    // العودة للجذر وإزالة كل الصفحات (بما فيها شاشة الصيانة)
    // لأن الـ Navigator يستخدم GlobalKey فلا يُزيله RestartWidget.
    final token = LocalStorage().readValue<String>(Constants.token);
    final route = (token != null && token.isNotEmpty)
        ? MyRoutes().userView
        : MyRoutes().authSiginIn;
    navigatorKey.currentState?.pushNamedAndRemoveUntil(route, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0A0F1E), Color(0xFF0E1428), AppColor.blackColor],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // ── الرسم المتحرك: حلقات نابضة + ترس دوّار ──────────────
                  SizedBox(
                    width: 220.r,
                    height: 220.r,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // حلقات نابضة
                        AnimatedBuilder(
                          animation: _pulse,
                          builder: (_, __) => CustomPaint(
                            size: Size(220.r, 220.r),
                            painter: _PulseRingsPainter(
                              progress: _pulse.value,
                              color: AppColor.k1primeryColor,
                            ),
                          ),
                        ),
                        // الدائرة الأساسية
                        Container(
                          width: 128.r,
                          height: 128.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColor.k1primeryColor,
                                AppColor.k1primeryColor.withValues(alpha: 0.7),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.k1primeryColor
                                    .withValues(alpha: 0.35),
                                blurRadius: 30,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        // ترس دوّار
                        RotationTransition(
                          turns: _spin,
                          child: Icon(
                            Icons.settings_rounded,
                            size: 68.r,
                            color: AppColor.whiteColor,
                          ),
                        ),
                        // ترس صغير معاكس الاتجاه (لمسة احترافية)
                        Positioned(
                          right: 44.r,
                          bottom: 44.r,
                          child: RotationTransition(
                            turns: Tween<double>(begin: 1, end: 0)
                                .animate(_spin),
                            child: Icon(
                              Icons.settings_rounded,
                              size: 30.r,
                              color: AppColor.whiteColor.withValues(alpha: 0.85),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // شارة الحالة
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                    decoration: BoxDecoration(
                      color: AppColor.k1primeryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(50.r),
                      border: Border.all(
                        color: AppColor.k1primeryColor.withValues(alpha: 0.4),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _BlinkingDot(controller: _pulse),
                        SizedBox(width: 8.w),
                        Text(
                          loc.maintenance.toUpperCase(),
                          style: MyTextStyle().textStyleMedium12().copyWith(
                                color: AppColor.k1primeryColor,
                                letterSpacing: 1.2,
                              ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),
                  Text(
                    loc.maintenance_title,
                    textAlign: TextAlign.center,
                    style: MyTextStyle().textStyleSemiBold20().copyWith(
                          color: AppColor.whiteColor,
                          fontSize: 24.sp,
                        ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    loc.maintenance_message,
                    textAlign: TextAlign.center,
                    style: MyTextStyle().textStyleRegular14().copyWith(
                          color: const Color(0xFF9AA3B2),
                          height: 1.6,
                        ),
                  ),

                  const Spacer(flex: 3),

                  // زر إعادة المحاولة
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton.icon(
                      onPressed: _retry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.k1primeryColor,
                        foregroundColor: AppColor.whiteColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      icon: Icon(Icons.refresh_rounded, size: 22.r),
                      label: Text(
                        loc.try_again,
                        style: MyTextStyle().textStyleSemiBold16().copyWith(
                              color: AppColor.whiteColor,
                            ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// نقطة نابضة داخل شارة الحالة
class _BlinkingDot extends StatelessWidget {
  final AnimationController controller;
  const _BlinkingDot({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final v = (0.5 - (controller.value - 0.5).abs()) * 2; // 0→1→0
        return Container(
          width: 8.r,
          height: 8.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.k1primeryColor.withValues(alpha: 0.4 + 0.6 * v),
          ),
        );
      },
    );
  }
}

// حلقات نابضة متتالية خلف الأيقونة
class _PulseRingsPainter extends CustomPainter {
  final double progress;
  final Color color;
  _PulseRingsPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    const baseRadius = 64.0;
    const maxRadius = 108.0;
    for (int i = 0; i < 3; i++) {
      final t = (progress + i / 3) % 1.0;
      final radius = baseRadius + (maxRadius - baseRadius) * t;
      final opacity = (1 - t) * 0.35;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = color.withValues(alpha: opacity);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PulseRingsPainter old) =>
      old.progress != progress;
}
