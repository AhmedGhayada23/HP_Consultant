import 'package:flutter/material.dart';
import 'package:hb/core/data/models/course_details_model.dart';
import 'package:hb/core/styles/app_font.dart';

class DetailsCourseOverviewWidget extends StatelessWidget {
  final CourseDetailsModel courseDetails;
  const DetailsCourseOverviewWidget({super.key,required this.courseDetails});

  @override
  Widget build(BuildContext context) {
  return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          courseDetails.description,
          style: MyTextStyle().textStyleRegular14(),
        ),

      ],
    );
  }
}
