import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/auth_signup_cubit/auth_signup_cubit.dart';
import 'package:hb/core/cubit/city_cubit/city_cubit.dart';
import 'package:hb/core/cubit/city_cubit/city_state.dart';
import 'package:hb/core/cubit/country_cubit/country_cubit.dart';
import 'package:hb/core/cubit/country_cubit/country_state.dart';
import 'package:hb/core/cubit/industry_cubit/industry_cubit.dart';
import 'package:hb/core/cubit/industry_cubit/industry_state.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/core/widgets/validateWidget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/validators.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AsCompany extends StatelessWidget {
  const AsCompany({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cubit = context.read<AuthSignupCubit>();
    return Column(
      children: [
        SizedBox(height: 16.h),
        MyTextFieldWidget(
          controller: cubit.campoanyNameController,
          hintText: loc.company_name,
          validator: (value) => Validators.required(value, context),
        ),
        SizedBox(height: 16.h),
        MyTextFieldWidget(
          controller: cubit.registrationNumberController,
          hintText: loc.registration_number,
          validator: (value) => Validators.required(value, context),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 16.h),
        ValidateWidget(
          validator: (value) {
            if (cubit.industryController.text.isEmpty) {
              return '${loc.this_field} ${loc.is_required}';
            }
            return null;
          },
          child: BlocBuilder<IndustryCubit, IndustryState>(
            builder: (context, state) {
              final isAr =
                  Localizations.localeOf(context).languageCode == 'ar';
              return Skeletonizer(
                enabled: state.isLoading,
                child: CustomDropdown(
                  hint: loc.industry,
                  items: state.industries
                      .map((e) => e.displayName(isAr))
                      .toList(),
                  onChanged: (value) {
                    // نحفظ قيمة الـ API (value) المقابلة للاسم المختار
                    final selected = state.industries.firstWhere(
                      (e) => e.displayName(isAr) == value,
                      orElse: () => state.industries.first,
                    );
                    cubit.industryController.text = selected.value;
                  },
                ),
              );
            },
          ),
        ),

        SizedBox(height: 16.h),
        ValidateWidget(
          validator: (value) {
            final countryState = context.read<CountryCubit>().state;
            if (countryState.selectedCountryId == null) {
              return '${loc.this_field} ${loc.is_required}';
            }
            return null;
          },
          child: BlocBuilder<CountryCubit, CountryState>(
            builder: (context, state) {
              return Skeletonizer(
                enabled: state.isLoading,
                child: CustomDropdown(
                  hint: state.isLoading
                      ? loc.main_country
                      : (state.selectedCountryName ?? loc.main_country),
                  items: state.countries.map((country) => country.name).toList(),
                  onChanged: (value) {
                    context.read<CountryCubit>().selectCountryByName(value);
                    // فرّغ المدينة المختارة سابقاً عند تغيير البلد
                    context.read<CityCubit>().reset();
                    for (var country in state.countries) {
                      if (country.name == value) {
                        context.read<CityCubit>().fetchCities(country.id);
                        break;
                      }
                    }
                  },
                ),
              );
            },
          ),
        ),

        SizedBox(height: 16.h),

        ValidateWidget(
          validator: (value) {
            final cityState = context.read<CityCubit>().state;
            if (cityState.selectedCityId == null) {
              return '${loc.this_field} ${loc.is_required}';
            }
            return null;
          },

          child: BlocBuilder<CityCubit, CityState>(
            builder: (context, state) {
              // مفتاح مرتبط بالبلد: تغيير البلد يعيد إنشاء الدروب-داون فارغاً
              final countryId =
                  context.read<CountryCubit>().state.selectedCountryId;
              return Skeletonizer(
                enabled: state.isLoading,
                child: CustomDropdown(
                  key: ValueKey('city_$countryId'),
                  hint: state.isLoading
                      ? loc.main_city
                      : (state.selectedCityName ?? loc.main_city),
                  items: state.cities.map((country) => country.name).toList(),
                  onChanged: (value) {
                    context.read<CityCubit>().selectCityByName(value);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
