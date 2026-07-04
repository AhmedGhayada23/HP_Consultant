import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hb/core/cubit/city_cubit/city_cubit.dart';
import 'package:hb/core/cubit/city_cubit/city_state.dart';
import 'package:hb/core/cubit/country_cubit/country_cubit.dart';
import 'package:hb/core/cubit/country_cubit/country_state.dart';
import 'package:hb/core/cubit/profile_cubit/profile_cubit.dart';
import 'package:hb/core/data/models/user_model.dart';
import 'package:hb/core/widgets/custom_dropdown.dart';
import 'package:hb/core/widgets/my_text_field_widget.dart';
import 'package:hb/l10n/app_localizations.dart';
import 'package:hb/utils/validators.dart';

class CompanyProfile extends StatefulWidget {
  final CompanyModel? company;
  const CompanyProfile({super.key, this.company});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<ProfileCubit>();
    context.read<CountryCubit>().fetchCountries();
    cubit.companyNameController.text = widget.company?.name ?? '';
    cubit.reqistrationNumberController.text = widget.company?.taxId ?? '';
    cubit.industryController.text = widget.company?.industry ?? '';
    // Country pre-selection is handled in ProfileView.initState via userModel.country
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cubit = context.read<ProfileCubit>();
    return Column(
      children: [
        SizedBox(height: 20.h),
        MyTextFieldWidget(
          controller: cubit.companyNameController,
          validator: (value)=> Validators.required(value, context),
          hintText: loc.company_name,
        ),
        SizedBox(height: 16.h),
        MyTextFieldWidget(
          controller: cubit.reqistrationNumberController,
          validator:(value)=> Validators.required(value, context),
          keyboardType: TextInputType.number,
          hintText: loc.registration_number,
        ),
        SizedBox(height: 16.h),
        MyTextFieldWidget(
          controller: cubit.industryController,
          validator:(value)=> Validators.required(value, context),
          hintText: loc.industry,
        ),
        SizedBox(height: 16.h),
        BlocBuilder<CountryCubit, CountryState>(
          builder: (context, state) {
            if (state.isLoading) {
              CustomDropdown(
                hint: AppLocalizations.of(context)!.main_country,
                items: [],
                onChanged: (value) {},
              );
            }
            return CustomDropdown(
              hint: state.selectedCountryName ?? AppLocalizations.of(context)!.main_country,
              items: state.countries.map((country) => country.name).toList(),
              selectedValue: state.selectedCountryName,
              onChanged: (value) {
                context.read<CountryCubit>().selectCountryByName(value);
                for (var country in state.countries) {
                  if (country.name == value) {
                    context.read<CityCubit>().fetchCities(country.id);
                    break;
                  }
                }
              },
            );
          },
        ),
        SizedBox(height: 16.h),
        BlocBuilder<CityCubit, CityState>(
          builder: (context, state) {
            if (state.isLoading) {
              CustomDropdown(
                hint: AppLocalizations.of(context)!.main_city,
                items: [],
                onChanged: (value) {},
              );
            }
            return CustomDropdown(
              hint: state.selectedCityName ?? AppLocalizations.of(context)!.main_city,
              selectedValue: state.selectedCityName,
              items: state.cities.map((country) => country.name).toList(),
              onChanged: (value) {
                context.read<CityCubit>().selectCityByName(value);
              },
            );
          },
        ),
      ],
    );
  }
}
