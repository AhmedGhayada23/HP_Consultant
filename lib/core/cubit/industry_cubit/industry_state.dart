import 'package:hb/core/data/models/industry_model.dart';

class IndustryState {
  final bool isLoading;
  final List<IndustryModel> industries;
  final String? errorMessage;

  IndustryState({
    this.isLoading = false,
    this.industries = const [],
    this.errorMessage,
  });

  IndustryState copyWith({
    bool? isLoading,
    List<IndustryModel>? industries,
    String? errorMessage,
  }) {
    return IndustryState(
      isLoading: isLoading ?? this.isLoading,
      industries: industries ?? this.industries,
      errorMessage: errorMessage,
    );
  }
}
