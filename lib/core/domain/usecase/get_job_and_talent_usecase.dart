// domain/usecases/get_recent_invoices_usecase.dart

import 'package:flutter/widgets.dart';
import 'package:hb/core/data/models/job_details_modle.dart';
import 'package:hb/core/data/models/jobs_model.dart';
import 'package:hb/core/data/models/payment_types_model.dart';
import 'package:hb/core/data/models/project_types_model.dart';
import 'package:hb/core/data/models/skills_model.dart';
import 'package:hb/core/domain/repository/job_and_talent_repository.dart';

class GetJobAndTalentUsecase {
  final JobAndTalentRepository repository;

  GetJobAndTalentUsecase(this.repository);

  Future<List<JobsModel>> call({
    String? name,
    String? status,
    String? createdOn,
    String? deadline,
  }) {
    return repository.getJobs(name: name, status: status, createdOn: createdOn, deadline: deadline);
  }

  Future<void> addJob({BuildContext? context, required Map<String, dynamic> jobData}) {
    return repository.addJob(context: context, jobData: jobData);
  }

  Future<List<SkillsModel>> getSkills() {
    return repository.getSkills();
  }

  Future<List<ProjectTypesModel>> getProjectTypes() {
    return repository.getProjectTypes();
  }

  Future<List<PaymentTypesModel>> getPaymentTypes() {
    return repository.getPaymentTypes();
  }

  Future<JobDetailsModle> getJobsDetails(int jobId) {
    return repository.getJobsDetails(jobId);
  }

  Future<String> updateJob({
    required Map<String, dynamic> jobData,
    required int jobId,
  }) {
    return repository.updateJob(jobData: jobData, jobId: jobId);
  }

  Future<void> closeJob({BuildContext? context, required int jobId}) {
    return repository.closeJob(context: context, jobId: jobId);
  }
}
