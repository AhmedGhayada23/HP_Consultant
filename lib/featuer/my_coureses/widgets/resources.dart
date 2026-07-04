import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/data/models/my_course_details_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button_border.dart';
import 'package:hb/featuer/file_web_view/file_web_view.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:vector_graphics/vector_graphics.dart';

class Resources extends StatelessWidget {
  final List<MyLessonMaterial> materials;
  const Resources({super.key, this.materials = const []});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc.resources, style: MyTextStyle().textStyleSemiBold20()),
        SizedBox(height: 20.h),
        if (materials.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Text(
              'No resources available.',
              style: MyTextStyle().textStyleRegular14(),
            ),
          )
        else
          ...materials.map(
            (material) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: AppColor.gray5,
                ),
                child: Column(
                  children: [
                    ListTile(
                      minLeadingWidth: 0,
                      minTileHeight: 0,
                      minVerticalPadding: 0,
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 39.w,
                        height: 43.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: AppColor.k1primeryColor.withValues(alpha: 0.15),
                        ),
                        child: Center(
                          child: VectorGraphic(
                            loader: AssetBytesLoader(AppSvg.fileSvg),
                          ),
                        ),
                      ),
                      title: Text(
                        material.name,
                        style: MyTextStyle().textStyleRegular14(),
                      ),
                      subtitle: Text(
                        material.typeLabel,
                        style: MyTextStyle().textStyleRegular11(),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    CustomButtonBorder(
                      // معاينة الملف بفتحه داخل عارض الملفات بدل التنزيل
                      onTap: () {
                        final url = material.url ?? '';
                        if (url.isEmpty) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FileWebViewPage(
                              fileName: material.name,
                              fileUrl: url,
                            ),
                          ),
                        );
                      },
                      borderColor: AppColor.k1primeryColor,
                      text: loc.view_file,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
