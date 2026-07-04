import 'package:hb/core/data/models/details_job_talent_model.dart';

abstract class DetailsJobTalentDataSource {
  Future<DetailsJobTalentModel> getDetailsJobTalent();
}

class DetailsJobTalentDataSourceImpl extends DetailsJobTalentDataSource {
  @override
  Future<DetailsJobTalentModel> getDetailsJobTalent() async {
    await Future.delayed(Duration(seconds: 2));

    return DetailsJobTalentModel(
      id: 1,
      skils: 'React - HTML/CSS - JavaScript - REST APIs - Git',
      description:  'HB Consulting is looking for a skilled frontend developer to assist with UI upgrades for a client in the finance sector. Responsibilities include refactoring existing components, working with REST APIs, and ensuring mobile responsiveness.\n\nExpected Deliverables:\n- Refactored component structure (React)\n- Optimized performance on desktop and mobile\n- Integrated API endpoints from back-end team\n\nLocation Preference: Remote (EU timezone preferred)\nExperience Level: 2–5 years',
    );
  }
}
