import 'package:hb/core/data/models/user_model.dart';

class ProfileState {
  final ProfileResponseModel? userModel;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final bool imagePicked;
  ProfileState({
    this.userModel,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.imagePicked = false,
  });

  ProfileState copyWith({
    ProfileResponseModel? userModel,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    bool? imagePicked,
  }) {
    return ProfileState(
      userModel: userModel ?? this.userModel,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      imagePicked: imagePicked ?? this.imagePicked,
    );
  }
}
