import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hb/core/cubit/auth_signup_cubit/auth_signup_state.dart';
import 'package:hb/core/cubit/country_cubit/country_cubit.dart';
import 'package:hb/core/cubit/city_cubit/city_cubit.dart';
import 'package:hb/core/data/models/register_model.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/service_locator/usecases.dart';

enum UserType { company, consultant, student, accountingClient }

enum CompanyType { small, medium, large }

class AuthSignupCubit extends Cubit<AuthSignupState> {
  AuthSignupCubit() : super(AuthSignupState());

  UserType? selectedUserType;
  CompanyType? selectedCompanyType;

  void setUserType(UserType type) {
    selectedUserType = type;
  }

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source, imageQuality: 70);
      if (image != null) {
        selectedImage = File(image.path);
        emit(state.copyWith(imagePicked: true));
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void clearImage() {
    selectedImage = null;
    emit(state.copyWith(imagePicked: false));
  }

  File? cvFile;

  Future<void> pickCvFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );
      if (result != null && result.files.single.path != null) {
        cvFile = File(result.files.single.path!);
        cvController.text = result.files.single.name;
        emit(state.copyWith(cvPicked: true));
      }
    } catch (e) {
      debugPrint('Error picking CV: $e');
    }
  }

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController campoanyNameController = TextEditingController();
  final TextEditingController registrationNumberController = TextEditingController();
  final TextEditingController industryController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController protfolioLink1Controller = TextEditingController();
  final TextEditingController protfolioLink2Controller = TextEditingController();
  final TextEditingController cvController = TextEditingController();
  final TextEditingController hourlyRateController = TextEditingController();
  final TextEditingController schoolUniversityController = TextEditingController();
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController businessEmailController = TextEditingController();
  final TextEditingController taxIDController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  int? selectedProfessionId;
  List<int> selectedSkillIds = [];
  String? selectedTaxType;

  void setTaxType(String value) {
    selectedTaxType = value;
  }

  void setProfessionId(int id) {
    selectedProfessionId = id;
  }

  void setSkillIds(List<int> ids) {
    selectedSkillIds = ids;
  }

  void toggleTermsAccepted(bool value) {
    emit(state.copyWith(termsAccepted: value));
  }

  void signUp(BuildContext context) async {
    if (!state.termsAccepted) {
      showCustomSnackBar(context, 'Please accept Terms & Conditions', SnackBarType.error);
      return;
    }
    if (selectedUserType == null) {
      showCustomSnackBar(context, 'User type is not selected', SnackBarType.error);
      return;
    }

    emit(state.copyWith(loading: true));

    try {
      final registerModel = _buildRegisterModel(context);
      await UseCases.getAuthUseCase.register(context: context, registerModel: registerModel);
      emit(state.copyWith(loading: false, success: true));
    } catch (e) {
      emit(state.copyWith(loading: false, success: false, errorMessage: e.toString()));
    }
  }

  RegisterModel _buildRegisterModel(BuildContext context) {
    final countryState = context.read<CountryCubit>().state;
    final cityState = context.read<CityCubit>().state;
    final type = _getUserTypeString(selectedUserType);

    switch (selectedUserType!) {
      case UserType.company:
        return RegisterModel(
          profileImage: selectedImage,
          fullName: fullNameController.text.trim(),
          email: emailController.text.trim(),
          codeCountry: countryState.selectedCountryCode ?? '',
          mobileNumber: mobileNumberController.text.trim(),
          password: passwordController.text.trim(),
          type: type,
          termsAccepted: state.termsAccepted,
          companyName: campoanyNameController.text.trim(),
          registrationNumber: registrationNumberController.text.trim(),
          industry: industryController.text.trim(),
          mainCountryId: countryState.selectedCountryId,
          mainCityId: cityState.selectedCityId,
        );

      case UserType.consultant:
        return RegisterModel(
          profileImage: selectedImage,
          fullName: fullNameController.text.trim(),
          email: emailController.text.trim(),
          codeCountry: countryState.selectedCountryCode ?? '',
          mobileNumber: mobileNumberController.text.trim(),
          password: passwordController.text.trim(),
          type: type,
          termsAccepted: state.termsAccepted,
          professionId: selectedProfessionId,
          skillIds: selectedSkillIds.isNotEmpty ? selectedSkillIds : null,
          hourlyRate: hourlyRateController.text.trim(),
          portfolioUrl1: protfolioLink1Controller.text.trim(),
          portfolioUrl2: protfolioLink2Controller.text.trim(),
          cv: cvFile,
        );

      case UserType.student:
        return RegisterModel(
          profileImage: selectedImage,
          fullName: fullNameController.text.trim(),
          email: emailController.text.trim(),
          codeCountry: countryState.selectedCountryCode ?? '',
          mobileNumber: mobileNumberController.text.trim(),
          password: passwordController.text.trim(),
          type: type,
          termsAccepted: state.termsAccepted,
          schoolUniversity: schoolUniversityController.text.trim(),
          professionId: selectedProfessionId,
        );

      case UserType.accountingClient:
        return RegisterModel(
          profileImage: selectedImage,
          fullName: fullNameController.text.trim(),
          email: emailController.text.trim(),
          codeCountry: countryState.selectedCountryCode ?? '',
          mobileNumber: mobileNumberController.text.trim(),
          password: passwordController.text.trim(),
          type: type,
          termsAccepted: state.termsAccepted,
          businessName: businessNameController.text.trim(),
          businessEmail: businessEmailController.text.trim(),
          taxId: taxIDController.text.trim(),
          taxType: selectedTaxType,
        );
    }
  }

  String _getUserTypeString(UserType? type) {
    switch (type) {
      case UserType.company:
        return "company";
      case UserType.consultant:
        return "consultant";
      case UserType.student:
        return "student";
      case UserType.accountingClient:
        return "accounting";
      default:
        return "student";
    }
  }

  @override
  Future<void> close() {
    fullNameController.dispose();
    emailController.dispose();
    mobileNumberController.dispose();
    campoanyNameController.dispose();
    registrationNumberController.dispose();
    industryController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    protfolioLink1Controller.dispose();
    protfolioLink2Controller.dispose();
    cvController.dispose();
    hourlyRateController.dispose();
    schoolUniversityController.dispose();
    businessNameController.dispose();
    businessEmailController.dispose();
    taxIDController.dispose();
    addressController.dispose();
    websiteController.dispose();
    notesController.dispose();
    return super.close();
  }
}
