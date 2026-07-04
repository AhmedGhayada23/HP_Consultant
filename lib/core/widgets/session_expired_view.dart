import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/local_storage.dart';
import 'package:hb/core/navigation/app_navigator.dart';
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/session_expired_service.dart';
import 'package:hb/l10n/app_localizations.dart';

/// نافذة "انتهت الجلسة" — تظهر عند 401 ولا تُغلق إلا بتسجيل الخروج
class SessionExpiredView extends StatefulWidget {
  const SessionExpiredView({super.key});

  @override
  State<SessionExpiredView> createState() => _SessionExpiredViewState();
}

class _SessionExpiredViewState extends State<SessionExpiredView>
    with TickerProviderStateMixin {
  // دخول: تلاشٍ + تكبير خفيف
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  )..forward();
  late final Animation<double> _fade =
      CurvedAnimation(parent: _entrance, curve: Curves.easeOut);
  late final Animation<double> _scale =
      CurvedAnimation(parent: _entrance, curve: Curves.easeOutBack);

  // نبض خفيف مستمر حول الأيقونة
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

  bool _loggingOut = false;

  @override
  void dispose() {
    _entrance.dispose();
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    if (_loggingOut) return;
    setState(() => _loggingOut = true);
    // حذف بيانات الجلسة (مثل تسجيل الخروج)
    await LocalStorage().removeKey(Constants.token);
    await LocalStorage().removeKey(Constants.userId);
    SessionExpiredService.instance.reset();
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      MyRoutes().authSiginIn,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    // منع إغلاق النافذة بزر الرجوع — الخروج فقط عبر الزر
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // خلفية داكنة مع تمويه خفيف
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: AppColor.blackColor.withValues(alpha: 0.55)),
            ),
            Center(
              child: FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 28.w),
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _animatedIcon(),
                        SizedBox(height: 24.h),
                        Text(
                          loc.session_expired_title,
                          textAlign: TextAlign.center,
                          style: MyTextStyle().textStyleSemiBold20(),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          loc.session_expired_message,
                          textAlign: TextAlign.center,
                          style: MyTextStyle().textStyleRegular14().copyWith(
                                color: AppColor.gray2,
                                height: 1.5,
                              ),
                        ),
                        SizedBox(height: 28.h),
                        _loggingOut
                            ? SizedBox(
                                height: 50.h,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColor.k1primeryColor,
                                  ),
                                ),
                              )
                            : CustomButton(
                                onTap: _logout,
                                color: AppColor.k1primeryColor,
                                text: loc.log_out,
                                icons: Icon(Icons.logout_rounded,
                                    size: 20.r, color: AppColor.whiteColor),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // أيقونة قفل مع حلقات نبض خفيفة
  Widget _animatedIcon() {
    return SizedBox(
      width: 110.r,
      height: 110.r,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              _ring(0.0),
              _ring(0.5),
              child!,
            ],
          );
        },
        child: Container(
          width: 72.r,
          height: 72.r,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.k1primeryColor,
          ),
          child: Icon(Icons.lock_clock_outlined,
              size: 38.r, color: AppColor.whiteColor),
        ),
      ),
    );
  }

  // حلقة تتمدّد وتتلاشى (نبض)
  Widget _ring(double offset) {
    final t = (_pulse.value + offset) % 1.0;
    final size = 72.r + (38.r * t);
    return Opacity(
      opacity: (1 - t) * 0.35,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColor.k1primeryColor, width: 2),
        ),
      ),
    );
  }
}
