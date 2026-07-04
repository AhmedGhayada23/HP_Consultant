import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/cubit/details_jobs_marketplace_cubit/details_jobs_marketplace_state.dart';
import 'package:hb/core/service_locator/usecases.dart';

class DetailsJobsMarketplaceCubit extends Cubit<DetailsJobsMarketplaceState> {
  DetailsJobsMarketplaceCubit() : super(DetailsJobsMarketplaceState());

  Future<void> fetchDetailsJobsMarketplace(int id) async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final data = await UseCases.getDetailsJobsMarketplaceUsecase(id);
      emit(state.copyWith(data: data, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
