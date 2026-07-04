import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/profile_cubit/profile_cubit.dart';
import 'package:hb/core/data/models/user_model.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/validators.dart';

class AccountingClintProfile extends StatefulWidget {
  final ProfileResponseModel userModel;
  const AccountingClintProfile({super.key, required this.userModel});

  @override
  State<AccountingClintProfile> createState() => _AccountingClintProfileState();
}

class _AccountingClintProfileState extends State<AccountingClintProfile> {
  @override
  void initState() {
    super.initState();
    // تعبئة الحقول من business_information في /profile/me
    final cubit = context.read<ProfileCubit>();
    final business = widget.userModel.user.accountingProfile;
    if (business != null) {
      cubit.businessNameController.text = business.businessName;
      cubit.businessEmailController.text = business.businessEmail;
      cubit.taxIDController.text = business.taxId;
      if (business.taxType.isNotEmpty) {
        cubit.selectedTaxType = business.taxType;
      }
    }
  }

  // قيمة tax_type المرسَلة للسيرفر: individual / company / freelancer
  String _taxTypeValue(String label) {
    switch (label) {
      case 'Individual':
        return 'individual';
      case 'Company':
        return 'company';
      case 'Freelancer':
        return 'freelancer';
      default:
        return label.toLowerCase();
    }
  }

  // عرض القيمة المخزّنة (lowercase) كعنوان مناسب في الـ dropdown
  String? _taxTypeLabel(String? value) {
    switch (value) {
      case 'individual':
        return 'Individual';
      case 'company':
        return 'Company';
      case 'freelancer':
        return 'Freelancer';
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cubit = context.read<ProfileCubit>();
    return Column(
      children: [
        SizedBox(height: 20.h),
        MyTextFieldWidget(
          controller: cubit.businessNameController,
          validator: (value) => Validators.required(value, context),
          hintText: loc.business_name,
        ),
        SizedBox(height: 16.h),
        MyTextFieldWidget(
          controller: cubit.businessEmailController,
          validator: (value) => Validators.email(value, context),
          keyboardType: TextInputType.emailAddress,
          hintText: loc.business_email,
        ),
        SizedBox(height: 16.h),
        MyTextFieldWidget(
          controller: cubit.taxIDController,
          validator: (value) => Validators.required(value, context),
          keyboardType: TextInputType.number,
          // أرقام فقط + حد أقصى للطول
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 20,
          hintText: loc.tax_id,
        ),
        SizedBox(height: 16.h),
        CustomDropdown(
          hint: 'Tax Type',
          selectedValue: _taxTypeLabel(cubit.selectedTaxType),
          items: const ['Individual', 'Company', 'Freelancer'],
          onChanged: (value) => cubit.setTaxType(_taxTypeValue(value)),
        ),
      ],
    );
  }
}
