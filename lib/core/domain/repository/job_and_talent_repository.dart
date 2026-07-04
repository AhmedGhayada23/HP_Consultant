import 'package:flutter/widgets.dart';
import 'package:hb/core/data/datasource/job_and_talent_remote_datasource.dart';
import 'package:hb/core/data/models/job_details_modle.dart';
import 'package:hb/core/data/models/jobs_model.dart';
import 'package:hb/core/data/models/payment_types_model.dart';
import 'package:hb/core/data/models/project_types_model.dart';
import 'package:hb/core/data/models/skills_model.dart';

abstract class JobAndTalentRepository {
  Future<List<JobsModel>> getJobs({
    String? name,
    String? status,
    String? createdOn,
    String? deadline,
  });
  Future<void> addJob({BuildContext? context, required Map<String, dynamic> jobData});
  Future<String> updateJob({
    required Map<String, dynamic> jobData,
    required int jobId,
  });
  Future<void> closeJob({BuildContext? context, required int jobId});

  Future<List<SkillsModel>> getSkills();
  Future<JobDetailsModle> getJobsDetails(int jobId);
  Future<List<ProjectTypesModel>> getProjectTypes();
  Future<List<PaymentTypesModel>> getPaymentTypes();
}

class JobAndTalentRepositoryImpl extends JobAndTalentRepository {
  final JobAndTalentRemoteDatasource remoteDataSource;

  JobAndTalentRepositoryImpl(this.remoteDataSource);
  @override
  Future<List<JobsModel>> getJobs({
        String? name,
    String? status,
    String? createdOn,
    String? deadline,
  }) async {
    return await remoteDataSource.getJobs(name: name,status: status,createdOn: createdOn,deadline: deadline);
  }

  @override
  Future<void> addJob({BuildContext? context, required Map<String, dynamic> jobData}) async {
    return await remoteDataSource.addJob(context: context, jobData: jobData);
  }

  @override
  Future<List<SkillsModel>> getSkills() {
    return remoteDataSource.getSkills();
  }

  @override
  Future<List<ProjectTypesModel>> getProjectTypes() {
    return remoteDataSource.getProjectTypes();
  }

  @override
  Future<List<PaymentTypesModel>> getPaymentTypes() {
    return remoteDataSource.getPaymentTypes();
  }

  @override
  Future<JobDetailsModle> getJobsDetails(int jobId) {
    return remoteDataSource.getJobsDetails(jobId);
  }

  @override
  Future<String> updateJob({
    required Map<String, dynamic> jobData,
    required int jobId,
  }) {
    return remoteDataSource.updateJob(jobData: jobData, jobId: jobId);
  }

  @override
  Future<void> closeJob({BuildContext? context, required int jobId}) {
    return remoteDataSource.closeJob(context: context, jobId: jobId);
  }
}
