import 'package:flutter/widgets.dart';
import 'package:hb/core/data/datasource/profile_remote_data_source.dart';
import 'package:hb/core/data/models/user_model.dart';

abstract class ProfileRepository {
  Future<ProfileResponseModel> fetchUserProfile();
  Future<void> updateUserProfile({
    required BuildContext context,
    required Map<String, dynamic> profileData,
  });
  Future<void> changePassword({
    required BuildContext context,
    required String previousPassword,
    required String newPassword,
  });
  Future<void> deleteAccount({required String password});
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProfileResponseModel> fetchUserProfile() {
    return remoteDataSource.fetchUserProfile();
  }

  @override
  Future<void> updateUserProfile({
    required BuildContext context,
    required Map<String, dynamic> profileData,
  }) {
    return remoteDataSource.updateUserProfile(context: context, profileData: profileData);
  }

  @override
  Future<void> changePassword({
    required BuildContext context,
    required String previousPassword,
    required String newPassword,
  }) {
    return remoteDataSource.changePassword(
      context: context,
      previousPassword: previousPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<void> deleteAccount({required String password}) =>
      remoteDataSource.deleteAccount(password: password);
}
