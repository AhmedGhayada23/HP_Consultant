// lib/featuer/counsultants_directory/presentation/cubit/consultant_state.dart

import 'package:hb/core/data/models/consultant_category_model.dart';
import 'package:hb/core/data/models/consultant_model.dart';

class ConsultantState {
  final List<ConsultantModel>? data;
  final bool? loading;
  final String? errorMessage;

  // Filters
  final String search;
  final String availability; // all | available | busy
  final String selectedCategory; // '' = all (يحمل id التصنيف كنص)
  final String minBudget;
  final String maxBudget;

  // Categories (dropdown)
  final List<ConsultantCategoryModel>? categories;
  final bool categoriesLoading;

  ConsultantState({
    this.data,
    this.loading,
    this.errorMessage,
    this.search = '',
    this.availability = 'all',
    this.selectedCategory = '',
    this.minBudget = '',
    this.maxBudget = '',
    this.categories,
    this.categoriesLoading = false,
  });

  ConsultantState copyWith({
    List<ConsultantModel>? data,
    bool? loading,
    String? errorMessage,
    String? search,
    String? availability,
    String? selectedCategory,
    String? minBudget,
    String? maxBudget,
    List<ConsultantCategoryModel>? categories,
    bool? categoriesLoading,
  }) {
    return ConsultantState(
      data: data ?? this.data,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      search: search ?? this.search,
      availability: availability ?? this.availability,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      minBudget: minBudget ?? this.minBudget,
      maxBudget: maxBudget ?? this.maxBudget,
      categories: categories ?? this.categories,
      categoriesLoading: categoriesLoading ?? this.categoriesLoading,
    );
  }
}
