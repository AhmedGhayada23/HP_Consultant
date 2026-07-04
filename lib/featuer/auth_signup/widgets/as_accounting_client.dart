import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/auth_signup_cubit/auth_signup_cubit.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/validators.dart';

class AsAccountingClient extends StatelessWidget {
  const AsAccountingClient({super.key});

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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cubit = context.read<AuthSignupCubit>();
    return Column(
      children: [
        SizedBox(height: 16.h),
        MyTextFieldWidget(
          controller: cubit.businessNameController,
          hintText: loc.business_name,
          validator: (value) => Validators.required(value, context),
        ),
        SizedBox(height: 16.h),
        MyTextFieldWidget(
          controller: cubit.businessEmailController,
          hintText: loc.business_email,
          validator: (value) => Validators.email(value, context),
        ),
        SizedBox(height: 16.h),
        MyTextFieldWidget(
          controller: cubit.taxIDController,
          hintText: loc.tax_id,
          validator: (value) => Validators.required(value, context),
        ),
        SizedBox(height: 16.h),
        CustomDropdown(
          hint: 'Tax Type',
          selectedValue: cubit.selectedTaxType,
          items: const ['Individual', 'Company', 'Freelancer'],
          onChanged: (value) => cubit.setTaxType(_taxTypeValue(value)),
        ),
      ],
    );
  }
}
