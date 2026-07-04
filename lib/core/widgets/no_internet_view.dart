import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';

/// بوب-أب انقطاع/بطء الإنترنت باحترافية + أنيميشن خفيف.
/// isSlow = true → حالة "الاتصال بطيء جداً"، وإلا "لا يوجد اتصال بالإنترنت".
class NoInternetView extends StatefulWidget {
  final VoidCallback onRetry;
  final bool isSlow;
  const NoInternetView({super.key, required this.onRetry, this.isSlow = false});

  @override
  State<NoInternetView> createState() => _NoInternetViewState();
}

class _NoInternetViewState extends State<NoInternetView>
    with TickerProviderStateMixin {
  late final AnimationController _entrance; // دخول البطاقة
  late final AnimationController _pulse; // حلقات + نبض الأيقونة

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )..forward();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _entrance.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final accent =
        widget.isSlow ? const Color(0xffE5A000) : AppColor.k1primeryColor;

    final title = widget.isSlow
        ? (isAr ? 'الاتصال بطيء جداً' : 'Connection is too slow')
        : (isAr ? 'لا يوجد اتصال بالإنترنت' : 'No internet connection');
    final subtitle = widget.isSlow
        ? (isAr
            ? 'قد تستغرق العملية وقتاً أطول من المعتاد. يرجى التحقق من جودة الشبكة.'
            : 'This may take longer than usual. Please check your network quality.')
        : (isAr
            ? 'تحقق من اتصالك بالشبكة وحاول مجدداً.'
            : 'Check your network connection and try again.');
    final retryText = isAr ? 'إعادة المحاولة' : 'Retry';

    final scale = CurvedAnimation(parent: _entrance, curve: Curves.easeOutBack);
    final fade = CurvedAnimation(parent: _entrance, curve: Curves.easeOut);

    return Material(
      color: Colors.black.withValues(alpha: 0.55),
      child: Center(
        child: FadeTransition(
          opacity: fade,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.85, end: 1).animate(scale),
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                padding: EdgeInsets.fromLTRB(24.w, 36.h, 24.w, 28.h),
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(28.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.28),
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // أيقونة الشبكة + حلقات نابضة + نبض خفيف
                    SizedBox(
                      width: 150.r,
                      height: 150.r,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _pulse,
                            builder: (_, __) => CustomPaint(
                              size: Size(150.r, 150.r),
                              painter: _PulseRingsPainter(
                                progress: _pulse.value,
                                color: accent,
                              ),
                            ),
                          ),
                          Container(
                            width: 100.r,
                            height: 100.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: accent.withValues(alpha: 0.12),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _pulse,
                            builder: (_, child) {
                              final v =
                                  (0.5 - (_pulse.value - 0.5).abs()) * 2; // 0→1→0
                              return Transform.scale(
                                scale: 1 + 0.06 * v,
                                child: child,
                              );
                            },
                            child: Icon(
                              widget.isSlow
                                  ? Icons
                                      .signal_wifi_statusbar_connected_no_internet_4_rounded
                                  : Icons.wifi_off_rounded,
                              size: 52.r,
                              color: accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: MyTextStyle().textStyleSemiBold20(),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: MyTextStyle()
                          .textStyleRegular14()
                          .copyWith(color: AppColor.gray2, height: 1.55),
                    ),
                    SizedBox(height: 28.h),
                    SizedBox(
                      width: double.infinity,
                      height: 54.h,
                      child: ElevatedButton.icon(
                        onPressed: widget.onRetry,
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
                          retryText,
                          style: MyTextStyle().textStyleSemiBold16().copyWith(
                                color: AppColor.whiteColor,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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
    const baseRadius = 50.0;
    const maxRadius = 74.0;
    for (int i = 0; i < 3; i++) {
      final t = (progress + i / 3) % 1.0;
      final radius = baseRadius + (maxRadius - baseRadius) * t;
      final opacity = (1 - t) * 0.30;
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
