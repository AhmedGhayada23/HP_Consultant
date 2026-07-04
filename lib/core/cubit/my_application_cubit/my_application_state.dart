// lib/featuer/career_opportunities/presentation/cubit/my_application_state.dart

import 'package:hb/core/data/models/my_application_model.dart';

class MyApplicationState {
  final List<MyApplicationModel>? data;
  final bool? loading;
  final String? errorMessage;

  MyApplicationState({
    this.data,
    this.loading,
    this.errorMessage,
  });

  MyApplicationState copyWith({
    List<MyApplicationModel>? data,
    bool? loading,
    String? errorMessage,
  }) {
    return MyApplicationState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
