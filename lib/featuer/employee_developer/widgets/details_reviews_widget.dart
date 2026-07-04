import 'package:flutter/material.dart';
import 'package:hb/core/data/models/course_details_model.dart';
import 'package:hb/core/widgets/empty_state_widget.dart';
import 'package:hb/l10n/app_localizations.dart';

class DetailsReviewsWidget extends StatelessWidget {
  final CourseDetailsModel courseDetails;
  const DetailsReviewsWidget({super.key, required this.courseDetails});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return EmptyStateWidget(
      title: loc.reviews,
      subtitle: loc.no_data_available,
      icon: Icons.star_border,
    );
  }
}
