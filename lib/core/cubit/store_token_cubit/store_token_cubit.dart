import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/store_token_cubit/store_token_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class StoreTokenCubit extends Cubit<StoreTokenState> {
  StoreTokenCubit() : super(StoreTokenState());

  /// يرسل الـ FCM token للباك اند مرة واحدة (لغير الزائر)
  Future<void> storeToken() async {
    if (state.sent) return;
    try {
      await UseCases.storeTokenUsecase.call();
      emit(state.copyWith(sent: true));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
