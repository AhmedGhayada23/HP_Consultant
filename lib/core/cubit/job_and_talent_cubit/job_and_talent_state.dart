
import 'package:hb/core/data/models/jobs_model.dart';

class JobAndTalentState {
  final List<JobsModel>? jobData;
  final bool? loading;
  final String? errorMessage;

  JobAndTalentState({
     this.jobData,
     this.errorMessage,
     this.loading = false,
  });

  JobAndTalentState copyWith({
   List<JobsModel>? jobData,
   bool? loading,
   String? errorMessage,
  }){
    return JobAndTalentState(
      jobData: jobData ?? this.jobData,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
