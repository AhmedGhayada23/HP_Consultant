import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/city_cubit/city_cubit.dart';
import 'package:hb/core/cubit/country_cubit/country_cubit.dart';
import 'package:hb/core/cubit/profile_cubit/profile_cubit.dart';
import 'package:hb/core/cubit/profile_cubit/profile_state.dart';
import 'package:hb/core/cubit/user_cubit/user_cubit.dart';
import 'package:hb/core/data/models/user_model.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/featuer/profile_setting/widgets/consultant_profile.dart';
import 'package:hb/featuer/profile_setting/widgets/accounting_clint_profile.dart';
import 'package:hb/featuer/profile_setting/widgets/company_profile.dart';
import 'package:hb/featuer/profile_setting/widgets/student_profile.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:vector_graphics/vector_graphics.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  bool _prefilled = false; // لمنع تكرار التعبئة

  @override
  void initState() {
    super.initState();
    // جلب بيانات البروفايل (التعبئة تتم عند وصولها)
    context.read<ProfileCubit>().fetchUserProfile();
  }

  // تعبئة الحقول من البروفايل المجلوب (مرة واحدة)
  void _prefill(ProfileResponseModel m) {
    if (_prefilled) return;
    _prefilled = true;
    final cubit = context.read<ProfileCubit>();
    cubit.type.text = m.user.type;
    cubit.fullNameController.text = m.user.name;
    cubit.emailController.text = m.user.email;
    cubit.mobileNumberController.text = m.user.mobile;
    if (m.user.consultantProfile != null) {
      final cp = m.user.consultantProfile!;
      cubit.hourlyRateController.text = cp.hourlyRate ?? '';
      cubit.portfolioUrl1Controller.text = cp.portfolioUrl1 ?? '';
      cubit.portfolioUrl2Controller.text = cp.portfolioUrl2 ?? '';
      cubit.cvController.text = cp.cvUrl ?? '';
    }
    if (m.user.studentProfile != null) {
      final sp = m.user.studentProfile!;
      cubit.schoolUniversityController.text = sp.schoolUniversity ?? '';
      cubit.studentMajorController.text = sp.major ?? '';
      cubit.selectedStudentProfessionId = sp.professionId;
    }
    if (m.user.company != null) {
      context.read<CountryCubit>().selectCountryByName(m.country.name);
      context.read<CityCubit>().fetchCities(m.country.id);
      context.read<CityCubit>().selectCityByName(m.province.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final userCubit = context.watch<UserCubit>();

    final profileState = context.watch<ProfileCubit>().state;
    final profile = profileState.userModel;
    final bool loading = profileState.isLoading || profile == null;

    // بطاقة البروفايل حسب نوع المستخدم (تُبنى فقط بعد وصول البيانات)
    Widget? selectedProfile;
    if (profile != null) {
      switch (userCubit.userType) {
        case UserType.CompanyUser:
          selectedProfile = CompanyProfile(company: profile.user.company);
          break;
        case UserType.ConsultantUser:
          selectedProfile = ConsultantProfile(userModel: profile);
          break;
        case UserType.StudentUser:
          selectedProfile = const StudentProfile();
          break;
        case UserType.AccountingClintUser:
          selectedProfile = AccountingClintProfile(userModel: profile);
          break;
        case UserType.VisitorUser:
          selectedProfile = const SizedBox();
      }
    }

    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (prev, curr) => prev.userModel != curr.userModel,
      listener: (context, state) {
        if (state.userModel != null) _prefill(state.userModel!);
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColor.whiteColor),
          backgroundColor: AppColor.blackColor,
          title: Text(
            loc.profile,
            style: MyTextStyle().textStyleSemiBold16().copyWith(color: AppColor.whiteColor),
          ),
        ),
        bottomNavigationBar: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: state.isLoading == true
                  ? CircleAvatar(
                      key: const ValueKey('loader'),
                      radius: 32.r,
                      backgroundColor: AppColor.k1primeryColor,
                      child: Center(child: CircularProgressIndicator(color: AppColor.whiteColor)),
                    )
                  : Container(
                      color: AppColor.whiteColor,
                      height: 80.h,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      child: CustomButton(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            final countryState = context.read<CountryCubit>().state;
                            final cityState = context.read<CityCubit>().state;
                            final profileCubit = context.read<ProfileCubit>();
                            final userType = profileCubit.type.text;

                            // رمز الدولة: يُرسل فقط عند توفّره (قيمة فارغة تتحوّل
                            // إلى null على الخادم فتفشل قاعدة string)
                            final countryCode = countryState.selectedCountryCode ??
                                ((profile?.country.phoneCode.isNotEmpty ?? false)
                                    ? profile!.country.phoneCode
                                    : (profile?.user.countryCode ?? ''));

                            final Map<String, dynamic> profileData = {
                              'name': userType == 'company'
                                  ? profileCubit.companyNameController.text
                                  : profileCubit.fullNameController.text,
                              'email': profileCubit.emailController.text,
                              if (countryCode.isNotEmpty)
                                'country_code': countryCode,
                              'mobile': profileCubit.mobileNumberController.text,
                              'owner_name': profileCubit.fullNameController.text,
                              'type': userType,
                            };

                            if (userType == 'company') {
                              profileData.addAll({
                                'tax_id': profileCubit.reqistrationNumberController.text,
                                'industry': profileCubit.industryController.text,
                                'country_id': countryState.selectedCountryId,
                                'province_id': cityState.selectedCityId,
                              });
                            } else if (userType == 'consultant') {
                              profileData.addAll({
                                'hourly_rate': profileCubit.hourlyRateController.text,
                                'portfolio_url1': profileCubit.portfolioUrl1Controller.text,
                                'portfolio_url2': profileCubit.portfolioUrl2Controller.text,
                              });
                            } else if (userType == 'student') {
                              profileData['school_university'] =
                                  profileCubit.schoolUniversityController.text;
                              profileData['major'] =
                                  profileCubit.studentMajorController.text;
                              if (profileCubit.selectedStudentProfessionId != null) {
                                profileData['profession_id'] =
                                    profileCubit.selectedStudentProfessionId;
                              }
                            } else if (userType == 'accounting') {
                              profileData.addAll({
                                'contact_person': profileCubit.fullNameController.text,
                                'business_name': profileCubit.businessNameController.text,
                                'business_email': profileCubit.businessEmailController.text,
                                'tax_id': profileCubit.taxIDController.text,
                                if (profileCubit.selectedTaxType != null &&
                                    profileCubit.selectedTaxType!.isNotEmpty)
                                  'tax_type': profileCubit.selectedTaxType,
                              });
                            }

                            context.read<ProfileCubit>().changeProfile(
                              context: context,
                              profileData: profileData,
                            );
                          }
                        },
                        color: AppColor.k1primeryColor,
                        text: loc.submit,
                      ),
                    ),
            );
          },
        ),
        body: Form(
          key: _formKey,
          child: Skeletonizer(
            enabled: loading,
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 16.w, vertical: 32.h),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, state) {
                          final cubit = context.read<ProfileCubit>();
                          return Row(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 90.w,
                                    height: 90.h,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      color: AppColor.gray1,
                                      shape: BoxShape.circle,
                                      border: Border.all(width: 1.w, color: AppColor.borderColor),
                                    ),
                                    child: cubit.selectedImage != null
                                        ? Image.file(cubit.selectedImage!, fit: BoxFit.cover)
                                        : CachedNetworkImage(
                                            imageUrl: profile?.imageUrl ?? '',
                                            fit: BoxFit.cover,
                                            placeholder: (_, __) => Icon(
                                              Icons.person,
                                              size: 48.r,
                                              color: AppColor.gray4,
                                            ),
                                            errorWidget: (_, __, ___) => Icon(
                                              Icons.person,
                                              size: 48.r,
                                              color: AppColor.gray4,
                                            ),
                                          ),
                                  ),
                                  Positioned(
                                    right: 2,
                                    bottom: 2,
                                    child: GestureDetector(
                                      onTap: () {
                                        cubit.pickImage(ImageSource.gallery);
                                      },
                                      child: Container(
                                        width: 32.w,
                                        height: 32.h,
                                        decoration: BoxDecoration(
                                          color: AppColor.whiteColor,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(color: const Color.fromARGB(0, 0, 12, 33)),
                                          ],
                                        ),
                                        child: Center(
                                          child: VectorGraphic(
                                            loader: AssetBytesLoader(AppSvg.editSvg),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 8.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loading ? 'User Name' : profile.user.name,
                                    style: MyTextStyle().textStyleMedium16(),
                                  ),
                                  SizedBox(height: 4.h),
                                  GestureDetector(
                                    onTap: () {
                                      cubit.pickImage(ImageSource.gallery);
                                    },
                                    child: Text(
                                      loc.upload_image,
                                      style: MyTextStyle().textStyleMedium16().copyWith(
                                        color: AppColor.uploadImageColor,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      // أثناء التحميل: عناصر هيكلية؛ بعد الوصول: البطاقة الفعلية
                      if (loading)
                        Column(
                          children: List.generate(
                            4,
                            (i) => Padding(
                              padding: EdgeInsets.only(top: 16.h),
                              child: Container(
                                height: 56.h,
                                decoration: BoxDecoration(
                                  color: AppColor.gray5,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                            ),
                          ),
                        )
                      else if (selectedProfile != null)
                        selectedProfile,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
