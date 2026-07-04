import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/auth_signup_cubit/auth_signup_cubit.dart';
import 'package:hb/core/cubit/auth_signup_cubit/auth_signup_state.dart';
import 'package:hb/core/cubit/city_cubit/city_cubit.dart';
import 'package:hb/core/cubit/country_cubit/country_cubit.dart';
import 'package:hb/core/cubit/country_cubit/country_state.dart';
import 'package:hb/core/routes/my_routes.dart';
import 'package:hb/core/styles/app_color.dart';
import 'package:hb/core/styles/app_font.dart';
import 'package:hb/core/styles/app_photo.dart';
import 'package:hb/core/widgets/custom_button.dart';
import 'package:hb/core/widgets/custom_dropdown_popup.dart';
import 'package:hb/core/widgets/dashed_line.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:hb/core/widgets/my_text_field_password_widget.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/core/widgets/validateWidget.dart';
import 'package:hb/featuer/auth_signup/widgets/as_accounting_client.dart';
import 'package:hb/featuer/auth_signup/widgets/as_company.dart';
import 'package:hb/featuer/auth_signup/widgets/as_consultant.dart';
import 'package:hb/featuer/auth_signup/widgets/as_student.dart';
import 'package:hb/featuer/auth_signup/widgets/custom_checkbox_text_row.dart';
import 'package:hb/featuer/auth_signup/widgets/image_upload_row.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/validators.dart';

class AuthSignUpView extends StatefulWidget {
  final String title;
  const AuthSignUpView({super.key, required this.title});

  @override
  State<AuthSignUpView> createState() => _AuthSignUpViewState();
}

class _AuthSignUpViewState extends State<AuthSignUpView> {
  final _formKey = GlobalKey<FormState>();

  // مراجع محفوظة لاستخدامها بأمان داخل dispose()
  CountryCubit? _countryCubit;
  CityCubit? _cityCubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // احفظ المراجع للاستخدام في dispose (لا يجوز context.read هناك)
    _countryCubit = context.read<CountryCubit>();
    _cityCubit = context.read<CityCubit>();

    // Fetch countries
    context.read<CountryCubit>().fetchCountries();

    // تحديد نوع المستخدم بناءً على عنوان الشاشة
    final cubit = context.read<AuthSignupCubit>();
    final loc = AppLocalizations.of(context)!;

    if (widget.title == loc.as_company) {
      cubit.setUserType(UserType.company);
    } else if (widget.title == loc.as_consultant) {
      cubit.setUserType(UserType.consultant);
    } else if (widget.title == loc.as_student) {
      cubit.setUserType(UserType.student);
    } else if (widget.title == loc.as_accounting_client) {
      cubit.setUserType(UserType.accountingClient);
    }
  }

  @override
  void dispose() {
    _countryCubit?.reset();
    _cityCubit?.reset();
    super.dispose();
  }

  bool isUserType(BuildContext context, String key) {
    final loc = AppLocalizations.of(context)!;

    switch (key) {
      case 'as_company':
        return widget.title == loc.as_company;
      case 'as_consultant':
        return widget.title == loc.as_consultant;
      case 'as_student':
        return widget.title == loc.as_student;
      case 'as_accounting_client':
        return widget.title == loc.as_accounting_client;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthSignupCubit>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // الخلفية السوداء
                  Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    color: AppColor.blackColor,
                    child: Center(child: Image.asset(AppImage.logoAuthImage)),
                  ),

                  // الكارد فوق الخلفية الرمادية
                  Transform.translate(
                    offset: Offset(
                      0,
                      -(MediaQuery.of(context).size.height * 0.08),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 22.w,
                        right: 22.w,
                        bottom: 32.h,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 22.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${AppLocalizations.of(context)!.sign_up} ${widget.title}',
                            style: MyTextStyle().textStyleSemiBold16(),
                          ),
                          DashedLine(),
                          SizedBox(height: 24.h),
                          ImageUploadRow(title: widget.title),
                          SizedBox(height: 24.h),
                          MyTextFieldWidget(
                            controller: cubit.fullNameController,
                            hintText: AppLocalizations.of(context)!.full_name,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                Validators.required(value, context),
                          ),
                          SizedBox(height: 16.h),
                          MyTextFieldWidget(
                            controller: cubit.emailController,
                            hintText: AppLocalizations.of(
                              context,
                            )!.email_address,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                Validators.email(value, context),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              ValidateWidget(
                                validator: (value) {
                                  final countryState = context
                                      .read<CountryCubit>()
                                      .state;
                                  if (countryState.selectedCountryCode ==
                                      null) {
                                    return AppLocalizations.of(
                                      context,
                                    )!.is_required;
                                  }
                                  return null;
                                },

                                child: BlocBuilder<CountryCubit, CountryState>(
                                  builder: (context, state) {
                                    final countryCodes = state.countries
                                        .map((country) => country.phoneCode)
                                        .toList();

                                    return Skeletonizer(
                                      enabled: state.isLoading,
                                      child: SizedBox(
                                      width: 100.w,
                                      child: CustomDropdownPopup(
                                        hint: state.selectedCountryCode ?? '+',
                                        items: countryCodes.isNotEmpty
                                            ? countryCodes
                                            : [],
                                        selectedValue:
                                            state.selectedCountryCode,
                                        onChanged: (value) {
                                          context
                                              .read<CountryCubit>()
                                              .selectCountryByCode(value);
                                        },
                                      ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: MyTextFieldWidget(
                                  controller: cubit.mobileNumberController,
                                  hintText: AppLocalizations.of(
                                    context,
                                  )!.mobile_number,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  validator: (value) =>
                                      Validators.required(value, context),
                                ),
                              ),
                            ],
                          ),

                          // User specific fields
                          if (isUserType(context, 'as_company')) ...[
                            AsCompany(),
                          ] else if (isUserType(context, 'as_consultant')) ...[
                            AsConsultant(),
                          ] else if (isUserType(context, 'as_student')) ...[
                            AsStudent(),
                          ] else ...[
                            AsAccountingClient(),
                          ],

                          SizedBox(height: 16.h),
                          MyTextFieldPasswordWidget(
                            controller: cubit.passwordController,
                            hintText: AppLocalizations.of(context)!.password,
                            validator: (value) =>
                                Validators.password(value, context),
                          ),
                          SizedBox(height: 16.h),
                          MyTextFieldPasswordWidget(
                            controller: cubit.confirmPasswordController,
                            hintText: AppLocalizations.of(
                              context,
                            )!.confirm_password,
                            validator: (value) => Validators.match(
                              value,
                              cubit.passwordController.text,
                              context,
                              fieldName: AppLocalizations.of(
                                context,
                              )!.confirm_password,
                            ),
                          ),
                          SizedBox(height: 16.h),

                          BlocBuilder<AuthSignupCubit, AuthSignupState>(
                            builder: (context, state) {
                              return CustomCheckboxTextRow(
                                isChecked: state.termsAccepted,
                                onChanged: (value) {
                                  context
                                      .read<AuthSignupCubit>()
                                      .toggleTermsAccepted(value);
                                },
                                text: AppLocalizations.of(context)!.agree_terms,
                              );
                            },
                          ),

                          SizedBox(height: 24.h),

                          BlocBuilder<AuthSignupCubit, AuthSignupState>(
                            builder: (context, state) {
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                transitionBuilder: (child, animation) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                child: state.loading == true
                                    ? Row(
                                        children: [
                                          Spacer(),
                                          CircleAvatar(
                                            key: const ValueKey('loader'),
                                            radius: 32.r,
                                            backgroundColor:
                                                AppColor.k1primeryColor,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color: AppColor.whiteColor,
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                        ],
                                      )
                                    : CustomButton(
                                        onTap: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            cubit.signUp(context);
                                          }
                                        },
                                        color: AppColor.k1primeryColor,
                                        text: AppLocalizations.of(
                                          context,
                                        )!.sign_up,
                                      ),
                              );
                            },
                          ),

                          SizedBox(height: 24.h),
                          DashedLine(),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.dont_have_account,
                                style: MyTextStyle().textStyleRegular16(),
                              ),
                              SizedBox(width: 12.w),
                              InkWell(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  MyRoutes().authSiginIn,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.sign_up,
                                  style: MyTextStyle()
                                      .textStyleRegular16()
                                      .copyWith(
                                        color: AppColor.k1primeryColor,
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
