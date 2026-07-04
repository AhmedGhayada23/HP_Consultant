import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/config/constants.dart';
import 'package:hb/core/config/storage/local_storage.dart';
import 'package:hb/core/cubit/profile_cubit/profile_state.dart';
import 'package:hb/core/service_locator/usecases.dart';
import 'package:image_picker/image_picker.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState());

  File? selectedImage;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController type = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController countryCodeController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController reqistrationNumberController = TextEditingController();
  final TextEditingController industryController = TextEditingController();
  final TextEditingController hourlyRateController = TextEditingController();
  final TextEditingController portfolioUrl1Controller = TextEditingController();
  final TextEditingController portfolioUrl2Controller = TextEditingController();
  final TextEditingController cvController = TextEditingController();
  final TextEditingController schoolUniversityController = TextEditingController();
  final TextEditingController studentMajorController = TextEditingController();
  int? selectedStudentProfessionId;

  // Accounting client
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController businessEmailController = TextEditingController();
  final TextEditingController taxIDController = TextEditingController();
  String? selectedTaxType;

  void setTaxType(String value) {
    selectedTaxType = value;
  }

  @override
  Future<void> close() {
    type.dispose();
    fullNameController.dispose();
    emailController.dispose();
    countryCodeController.dispose();
    mobileNumberController.dispose();
    companyNameController.dispose();
    reqistrationNumberController.dispose();
    industryController.dispose();
    hourlyRateController.dispose();
    portfolioUrl1Controller.dispose();
    portfolioUrl2Controller.dispose();
    cvController.dispose();
    schoolUniversityController.dispose();
    studentMajorController.dispose();
    businessNameController.dispose();
    businessEmailController.dispose();
    taxIDController.dispose();
    return super.close();
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source, imageQuality: 70);

    if (image != null) {
      selectedImage = File(image.path);
      emit(state.copyWith(imagePicked: true));
    }
  }

  Future<void> changeProfile({
    required BuildContext context,
    required Map<String, dynamic> profileData,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // أضف الصورة للبيانات إن كانت موجودة
      final dataWithImage = {
        ...profileData,
        if (selectedImage != null) 'profileImage': selectedImage,
      };

      await UseCases.getProfileUsecase.updateProfile(context: context, profileData: dataWithImage);

      emit(state.copyWith(isLoading: false, isSuccess: true));

      // ✅ بعد النجاح: تصفير الصورة المختارة وإعادة جلب البيانات المحدّثة
      selectedImage = null;
      await fetchUserProfile();
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  // حذف الحساب — يرجّع true عند النجاح
  Future<bool> deleteAccount({required String password}) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await UseCases.getProfileUsecase.deleteAccount(password: password);
      emit(state.copyWith(isLoading: false));
      return true;
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      return false;
    }
  }

  Future<void> fetchUserProfile() async {
    emit(state.copyWith(isLoading: true));

    try {
      final user = await UseCases.getProfileUsecase.get();

      // خزّن معرّف المستخدم لاستخدامه في قناة Pusher الخاصة (private-user.{id})
      if (user.user.id != 0) {
        LocalStorage().writeValue(Constants.userId, user.user.id);
      }

      emit(state.copyWith(isLoading: false, userModel: user));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
