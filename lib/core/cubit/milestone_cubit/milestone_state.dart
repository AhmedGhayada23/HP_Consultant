import 'package:hb/core/data/models/milestone_model.dart';

class MilestoneState {
  final List<MilestoneModel>? milestone;
  final bool isLoading;
  final String? errorMessage;

  MilestoneState({this.milestone, this.isLoading = false, this.errorMessage});

  MilestoneState copyWith({
    List<MilestoneModel>? milestone,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MilestoneState(
      milestone: milestone ?? this.milestone,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
