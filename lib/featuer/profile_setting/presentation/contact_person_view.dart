import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/contact_person_cubit/contact_person_cubit.dart';
import 'package:hb/core/cubit/contact_person_cubit/contact_person_state.dart';
import 'package:hb/core/cubit/country_cubit/country_cubit.dart';
import 'package:hb/core/cubit/country_cubit/country_state.dart';
import 'package:hb/core/cubit/profile_cubit/profile_cubit.dart';
import 'package:hb/core/cubit/profile_cubit/profile_state.dart';
import 'package:hb/core/data/models/user_model.dart';
import 'package:hb/core/helper/message_snack_bar.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_dropdown_popup.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/core/widgets/validateWidget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/validators.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ContactPersonView extends StatefulWidget {
  const ContactPersonView({super.key});

  @override
  State<ContactPersonView> createState() => _ContactPersonViewState();
}

class _ContactPersonViewState extends State<ContactPersonView> {
  final _formKey = GlobalKey<FormState>();
  bool _prefilled = false; // لمنع تكرار تعبئة الحقول

  @override
  void initState() {
    super.initState();
    // جلب الدول + بيانات البروفايل (التعبئة تتم عند وصول البيانات)
    context.read<CountryCubit>().fetchCountries();
    context.read<ProfileCubit>().fetchUserProfile();
  }

  // تعبئة الحقول من البروفايل المجلوب (مرة واحدة)
  void _prefill(ProfileResponseModel profile) {
    if (_prefilled) return;
    _prefilled = true;
    final cubit = context.read<ContactPersonCubit>();
    cubit.fullNameController.text =
        profile.user.company?.name ?? profile.user.name;
    cubit.emailController.text = profile.user.email;
    cubit.phoneController.text = profile.user.mobile;
    cubit.ownerNameController.text = profile.user.name;

    context.read<CountryCubit>().selectCountryByCode(profile.user.countryCode);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cubit = context.read<ContactPersonCubit>();

    final profileState = context.watch<ProfileCubit>().state;
    final profile = profileState.userModel;
    // skeleton أثناء تحميل البروفايل أو قبل وصوله
    final bool loadingProfile = profileState.isLoading || profile == null;

    return MultiBlocListener(
      listeners: [
        // تعبئة الحقول عند وصول بيانات البروفايل
        BlocListener<ProfileCubit, ProfileState>(
          listenWhen: (prev, curr) => prev.userModel != curr.userModel,
          listener: (context, state) {
            if (state.userModel != null) _prefill(state.userModel!);
          },
        ),
        // نتيجة الإرسال
        BlocListener<ContactPersonCubit, ContactPersonState>(
          listenWhen: (prev, curr) =>
              prev.success != curr.success ||
              prev.errorMassage != curr.errorMassage,
          listener: (context, state) {
            if (state.success == true) {
              showCustomSnackBar(
                context,
                loc.update_profile_successfully,
                SnackBarType.success,
              );
              Navigator.pop(context); // الرجوع لصفحة الإعدادات (البيانات محدّثة)
            } else if (state.success == false && state.errorMassage != null) {
              showCustomSnackBar(
                context,
                state.errorMassage!.replaceAll('Exception:', '').trim(),
                SnackBarType.error,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColor.whiteColor),
          backgroundColor: AppColor.blackColor,
          title: Text(
            loc.contact_person,
            style: MyTextStyle().textStyleSemiBold16().copyWith(
              color: AppColor.whiteColor,
            ),
          ),
        ),

        bottomNavigationBar:
            BlocBuilder<ContactPersonCubit, ContactPersonState>(
              builder: (context, state) {
                return SizedBox(
                  height: 80.h, // ✅ ارتفاع ثابت
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: state.loading == true
                        ? Center(
                            key: const ValueKey('loader'),
                            child: CircleAvatar(
                              radius: 32.r,
                              backgroundColor: AppColor.k1primeryColor,
                              child: const CircularProgressIndicator(
                                color: AppColor.whiteColor,
                              ),
                            ),
                          )
                        : Container(
                            key: const ValueKey('button'),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            child: CustomButton(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  context
                                      .read<ContactPersonCubit>()
                                      .sendContactPersonData(
                                        context,
                                        userType: profile?.user.type ?? '',
                                      );
                                }
                              },
                              color: AppColor.k1primeryColor,
                              text: loc.submit,
                            ),
                          ),
                  ),
                );
              },
            ),
        body: Form(
          key: _formKey,
          child: Skeletonizer(
            enabled: loadingProfile,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 16.w,
                  vertical: 24.h,
                ),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      MyTextFieldWidget(
                        controller: cubit.ownerNameController,
                        validator: (value) =>
                            Validators.required(value, context),
                        hintText: loc.full_name,
                      ),
                      SizedBox(height: 16.h),
                      MyTextFieldWidget(
                        readOnly: true,
                        controller: cubit.emailController,
                        validator: (value) => Validators.email(value, context),
                        hintText: loc.email_address,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          ValidateWidget(
                            validator: (value) {
                              final countryState = context
                                  .read<CountryCubit>()
                                  .state;
                              if (countryState.selectedCountryCode == null) {
                                return 'Please select a country code';
                              }
                              return null;
                            },
                            child: BlocBuilder<CountryCubit, CountryState>(
                              builder: (context, state) {
                                if (state.isLoading) {
                                  return SizedBox(
                                    width: 100.w,
                                    child: CustomDropdownPopup(
                                      hint: '+',
                                      items: [],
                                    ),
                                  );
                                }

                                final countryCodes = state.countries
                                    .map((country) => country.phoneCode)
                                    .toList();

                                return SizedBox(
                                  width: 100.w,
                                  child: CustomDropdownPopup(
                                    hint: state.selectedCountryCode ?? '+',
                                    items: countryCodes.isNotEmpty
                                        ? countryCodes
                                        : [],
                                    selectedValue: state.selectedCountryCode,
                                    onChanged: (value) {
                                      context
                                          .read<CountryCubit>()
                                          .selectCountryByCode(value);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: MyTextFieldWidget(
                              controller: cubit.phoneController,
                              hintText: loc.mobile_number,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              // أرقام إنجليزية فقط + حد أقصى 15 خانة
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              maxLength: 15,
                              validator: (value) =>
                                  Validators.phone(value, context),
                            ),
                          ),
                        ],
                      ),
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
