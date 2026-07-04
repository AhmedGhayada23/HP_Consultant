import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/data/models/course_details_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';

class DetailsTrainerProfileWidget extends StatelessWidget {
  final CourseDetailsModel courseDetails;
  const DetailsTrainerProfileWidget({super.key, required this.courseDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 32.r,
            backgroundColor: AppColor.gray2,
          ),
          title: Text(courseDetails.trainer.name,style: MyTextStyle().textStyleSemiBold16(),),
          subtitle: Text(courseDetails.trainer.email,style: MyTextStyle().textStyleRegular14(),),
        ),
      ],
    );
  }
}
