import 'package:flutter/widgets.dart';
import 'package:hb/core/data/models/user_model.dart';
import 'package:hb/core/domain/repository/profile_repository.dart';

class ProfileUsecase {
  final ProfileRepository profileRepository;
  ProfileUsecase(this.profileRepository);

  Future<ProfileResponseModel> get() {
    return profileRepository.fetchUserProfile();
  }

  Future<void> updateProfile({
    required BuildContext context,
    required Map<String, dynamic> profileData,
  }) {
    return profileRepository.updateUserProfile(context: context, profileData: profileData);
  }

  Future<void> changePassword({
    required BuildContext context,
    required String previousPassword,
    required String newPassword,
  }) {
    return profileRepository.changePassword(
      context: context,
      previousPassword: previousPassword,
      newPassword: newPassword,
    );
  }

  Future<void> deleteAccount({required String password}) =>
      profileRepository.deleteAccount(password: password);
}
