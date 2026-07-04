import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/remote_dio.dart';
import 'package:hb/core/data/models/job_details_modle.dart';
import 'package:hb/core/data/models/jobs_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:hb/core/data/models/payment_types_model.dart';
import 'package:hb/core/data/models/project_types_model.dart';
import 'package:hb/core/data/models/skills_model.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/helper/server_message.dart';

abstract class JobAndTalentRemoteDatasource {
  Future<List<JobsModel>> getJobs({
    String? name,
    String? status,
    String? createdOn,
    String? deadline,
  });
  Future<JobDetailsModle> getJobsDetails(int jobId);
  Future<void> addJob({
    BuildContext? context,
    required Map<String, dynamic> jobData,
  });
  Future<String> updateJob({
    required Map<String, dynamic> jobData,
    required int jobId,
  });
  Future<void> closeJob({BuildContext? context, required int jobId});

  Future<List<SkillsModel>> getSkills();
  Future<List<ProjectTypesModel>> getProjectTypes();
  Future<List<PaymentTypesModel>> getPaymentTypes();
}

class JobAndTalentRemoteDatasourceImpl extends JobAndTalentRemoteDatasource {
  static final JobAndTalentRemoteDatasourceImpl _instance =
      JobAndTalentRemoteDatasourceImpl._internal();
  late final RemoteConnectionDio _remoteConnectionDio;

  /// Private constructor for singleton pattern
  JobAndTalentRemoteDatasourceImpl._internal() {
    _remoteConnectionDio = RemoteConnectionDio();
  }

  /// Factory constructor to return singleton instance
  factory JobAndTalentRemoteDatasourceImpl() {
    return _instance;
  }

  @override
  Future<List<JobsModel>> getJobs({
    String? name,
    String? status,
    String? createdOn,
    String? deadline,
  }) async {
    final Map<String, dynamic> queryParams = {
      if (name != null) 'name': name,
      if (status != null) 'status': status,
      if (createdOn != null) 'deadline_from': createdOn,
      if (deadline != null) 'deadline_to': deadline,
    };
    try {
      final response = await _remoteConnectionDio.dio.get(
        Constants.jobsUrl,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (_isSuccessfulResponse(response)) {
        final data = response.data;

        if (data == null ||
            data['data'] == null ||
            data['data']['jobs'] == null) {
          throw Exception('Jobs data is null');
        }

        final List jobsJson = data['data']['jobs'];

        return jobsJson.map((job) => JobsModel.fromJson(job)).toList();
      } else {
        throw Exception("Failed to load Jobs: Status ${response.statusCode}");
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching Jobs: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching Jobs: $e');
    }
  }

  @override
  Future<JobDetailsModle> getJobsDetails(int jobId) async {
    try {
      final response = await _remoteConnectionDio.dio.get(
        '${Constants.jobsUrl}/$jobId',
      );

      if (_isSuccessfulResponse(response)) {
        final data = response.data;

        if (data == null || data['data'] == null) {
          throw Exception('Jobs Details data is null');
        }

        final Map<String, dynamic> jobsJson = data['data'];

        return JobDetailsModle.fromJson(jobsJson);
      } else {
        throw Exception(
          "Failed to load Jobs Details: Status ${response.statusCode}",
        );
      }
    } on dio.DioException catch (e) {
      throw Exception(
        'Network error while fetching Jobs Details: ${e.message}',
      );
    } catch (e) {
      throw Exception('Unexpected error while fetching Jobs Details: $e');
    }
  }

  @override
  Future<void> addJob({
    BuildContext? context,
    required Map<String, dynamic> jobData,
  }) async {
    try {
      // ابنِ الـ FormData بدون files أولاً
      final formData = dio.FormData.fromMap({
        'title': jobData['title'],
        'description': jobData['description'],
        'type': jobData['type'],
        'payment_type': jobData['payment_type'],
        'budget_min': jobData['budget_min'],
        'budget_max': jobData['budget_max'],
        'deadline': jobData['deadline'],
        // نوع المشروع (slug صغير مثل consulting/development/design)
        'project_type':
            (jobData['project_type'] as String?)?.toLowerCase(),
      });

      // أضف required_skills كـ array
      final skills = jobData['required_skills'];
      if (skills is List) {
        for (final skill in skills) {
          formData.fields.add(MapEntry('required_skills[]', skill.toString()));
        }
      }

      // معرّفات الملفات المحذوفة (عند التعديل)
      final deletedFiles = jobData['deleted_files'];
      if (deletedFiles is List) {
        for (final id in deletedFiles) {
          formData.fields.add(MapEntry('deleted_files[]', id.toString()));
        }
      }

      // أضف الملفات من PlatformFile
      final files = jobData['files'];
      if (files is List && files.isNotEmpty) {
        for (final file in files) {
          if (file is PlatformFile) {
            if (file.bytes != null) {
              // Web أو عندك bytes
              formData.files.add(
                MapEntry(
                  'files[]',
                  dio.MultipartFile.fromBytes(file.bytes!, filename: file.name),
                ),
              );
            } else if (file.path != null) {
              // Mobile - عندك path حقيقي
              formData.files.add(
                MapEntry(
                  'files[]',
                  await dio.MultipartFile.fromFile(
                    file.path!,
                    filename: file.name,
                  ),
                ),
              );
            }
          }
        }
      }

      final response = await _remoteConnectionDio.dio.post(
        Constants.jobsUrl,
        data: formData,
        // احذف الـ options - Dio يضبط Content-Type تلقائياً مع FormData
      );

      if (!_isSuccessfulResponse(response)) {
        final rawMessage = response.data['message'];
        final serverMessage = ServerMessage.fromResponse(rawMessage);
        if (context != null && context.mounted) {
          showCustomSnackBar(
            context,
            serverMessage.asBullets,
            SnackBarType.error,
          );
        }
      }
    } on dio.DioException catch (e) {
      // اطبع التفاصيل عشان تشوف الـ response من الـ API
      log('DioException: ${e.response?.data}');
      log('DioException: ${e.response?.statusCode}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      log('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<List<SkillsModel>> getSkills() async {
    try {
      final response = await _remoteConnectionDio.dio.get(Constants.skillsUrl);

      if (_isSuccessfulResponse(response)) {
        final data = response.data;

        if (data == null ||
            data['data'] == null ||
            data['data']['skills'] == null) {
          throw Exception('Jobs data is null');
        }

        final List jobsJson = data['data']['skills'];

        return jobsJson.map((job) => SkillsModel.fromJson(job)).toList();
      } else {
        throw Exception("Failed to load Skills: Status ${response.statusCode}");
      }
    } on dio.DioException catch (e) {
      throw Exception('Network error while fetching Skills: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching Skills: $e');
    }
  }

  @override
  Future<List<ProjectTypesModel>> getProjectTypes() async {
    try {
      final response = await _remoteConnectionDio.dio.get(
        Constants.projectTypesUrl,
      );

      if (_isSuccessfulResponse(response)) {
        final data = response.data;

        if (data == null ||
            data['data'] == null ||
            data['data']['project_types'] == null) {
          throw Exception('Project types data is null');
        }
        final List projectTypesJson = data['data']['project_types'];
        return projectTypesJson
            .map((projectType) => ProjectTypesModel.fromJson(projectType))
            .toList();
      } else {
        throw Exception(
          "Failed to load Project Types: Status ${response.statusCode}",
        );
      }
    } on dio.DioException catch (e) {
      throw Exception(
        'Network error while fetching Project Types: ${e.message}',
      );
    } catch (e) {
      throw Exception('Unexpected error while fetching Project Types: $e');
    }
  }

  @override
  Future<List<PaymentTypesModel>> getPaymentTypes() async {
    try {
      final response = await _remoteConnectionDio.dio.get(
        Constants.paymentTypesUrl,
      );

      if (_isSuccessfulResponse(response)) {
        final data = response.data;

        if (data == null ||
            data['data'] == null ||
            data['data']['payment_types'] == null) {
          throw Exception('Payment types data is null');
        }
        final List paymentTypesJson = data['data']['payment_types'];
        return paymentTypesJson
            .map((paymentType) => PaymentTypesModel.fromJson(paymentType))
            .toList();
      } else {
        throw Exception(
          "Failed to load Payment Types: Status ${response.statusCode}",
        );
      }
    } on dio.DioException catch (e) {
      throw Exception(
        'Network error while fetching Payment Types: ${e.message}',
      );
    } catch (e) {
      throw Exception('Unexpected error while fetching Payment Types: $e');
    }
  }

  @override
  Future<String> updateJob({
    required Map<String, dynamic> jobData,
    required int jobId,
  }) async {
    try {
      // ابنِ الـ FormData بدون files أولاً
      final formData = dio.FormData.fromMap({
        'title': jobData['title'],
        'description': jobData['description'],
        'type': jobData['type'],
        'payment_type': jobData['payment_type'],
        'budget_min': jobData['budget_min'],
        'budget_max': jobData['budget_max'],
        'deadline': jobData['deadline'],
        // نوع المشروع (slug صغير مثل consulting/development/design)
        'project_type':
            (jobData['project_type'] as String?)?.toLowerCase(),
      });

      // أضف required_skills كـ array
      final skills = jobData['required_skills'];
      if (skills is List) {
        for (final skill in skills) {
          formData.fields.add(MapEntry('required_skills[]', skill.toString()));
        }
      }

      // معرّفات الملفات المحذوفة (عند التعديل)
      final deletedFiles = jobData['deleted_files'];
      if (deletedFiles is List) {
        for (final id in deletedFiles) {
          formData.fields.add(MapEntry('deleted_files[]', id.toString()));
        }
      }

      // أضف الملفات من PlatformFile
      final files = jobData['files'];
      if (files is List && files.isNotEmpty) {
        for (final file in files) {
          if (file is PlatformFile) {
            if (file.bytes != null) {
              // Web أو عندك bytes
              formData.files.add(
                MapEntry(
                  'files[]',
                  dio.MultipartFile.fromBytes(file.bytes!, filename: file.name),
                ),
              );
            } else if (file.path != null) {
              // Mobile - عندك path حقيقي
              formData.files.add(
                MapEntry(
                  'files[]',
                  await dio.MultipartFile.fromFile(
                    file.path!,
                    filename: file.name,
                  ),
                ),
              );
            }
          }
        }
      }

      final response = await _remoteConnectionDio.dio.post(
        '${Constants.jobsUrl}/$jobId',
        data: formData,
        // احذف الـ options - Dio يضبط Content-Type تلقائياً مع FormData
      );

      final serverMessage =
          ServerMessage.fromResponse(response.data['message']);
      if (!_isSuccessfulResponse(response)) {
        // الفشل: ارمِ رسالة السيرفر ليعرضها الـ cubit/view
        throw serverMessage.asBullets;
      }
      // النجاح: أعِد رسالة السيرفر
      return serverMessage.asBullets;
    } on dio.DioException catch (e) {
      // اطبع التفاصيل عشان تشوف الـ response من الـ API
      log('DioException: ${e.response?.data}');
      log('DioException: ${e.response?.statusCode}');
      throw 'Network error: ${e.message}';
    } catch (e) {
      // مرّر رسالة الفشل كما هي (رسالة السيرفر) بدون تغليفها
      log('Update job error: $e');
      rethrow;
    }
  }

  @override
  Future<void> closeJob({BuildContext? context, required int jobId}) {
    try {
      return _remoteConnectionDio.dio
          .post('${Constants.jobsUrl}/$jobId/close')
          .then((response) {
            if (!_isSuccessfulResponse(response)) {
              final rawMessage = response.data['message'];
              final serverMessage = ServerMessage.fromResponse(rawMessage);
              if (context != null && context.mounted) {
                showCustomSnackBar(
                  context,
                  serverMessage.asBullets,
                  SnackBarType.error,
                );
              }
              throw Exception(serverMessage.asBullets);
            } else {
              // رسالة النجاح من الخادم (message)
              final rawMessage = response.data['message'];
              final serverMessage = ServerMessage.fromResponse(rawMessage);
              if (context != null && context.mounted) {
                showCustomSnackBar(
                  context,
                  serverMessage.asBullets,
                  SnackBarType.success,
                );
              }
            }
          });
    } on dio.DioException catch (e) {
      // اطبع التفاصيل عشان تشوف الـ response من الـ API
      log('DioException: ${e.response?.data}');
      log('DioException: ${e.response?.statusCode}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      log('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  bool _isSuccessfulResponse(dio.Response response) {
    return response.statusCode == 200;
  }
}
