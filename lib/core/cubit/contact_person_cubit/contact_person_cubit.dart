import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/contact_person_cubit/contact_person_state.dart';
import 'package:hb/core/cubit/country_cubit/country_cubit.dart';
import 'package:hb/core/cubit/profile_cubit/profile_cubit.dart';
import 'package:hb/core/service_locator/usecases.dart';

class ContactPersonCubit extends Cubit<ContactPersonState> {
  ContactPersonCubit() : super(ContactPersonState());

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();


  Future<void> sendContactPersonData(BuildContext context, {required String userType}) async {
    emit(state.copyWith(loading: true, success: null, errorMassage: null));

    try {
      // رمز الدولة: يُرسل فقط عند توفّره (قيمة فارغة تتحوّل إلى null على
      // الخادم فتفشل قاعدة string)
      final countryCode =
          context.read<CountryCubit>().state.selectedCountryCode ?? '';
      await UseCases.getProfileUsecase.updateProfile(
        context: context,
        profileData: {
          'name': userType == 'company'
              ? fullNameController.text
              : ownerNameController.text,
          'mobile': phoneController.text,
          if (countryCode.isNotEmpty) 'country_code': countryCode,
          'type': userType,
          'email': emailController.text,
          'owner_name': ownerNameController.text,
        },
      );
      emit(state.copyWith(loading: false, success: true));

      // ✅ جلب بيانات البروفايل بعد نجاح التعديل فقط
      if (context.mounted) {
        context.read<ProfileCubit>().fetchUserProfile();
      }
    } catch (e) {
      // On error
      emit(state.copyWith(loading: false, success: false, errorMassage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    return super.close();
  }
}
