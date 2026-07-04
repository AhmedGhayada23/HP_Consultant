import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb/core/config/storage/local_storage.dart';
import 'package:hb/core/cubit/user_cubit/user_state.dart';

class UserCubit extends Cubit<UserStates> {
  UserCubit() : super(VisitorUserState());

  late UserType userType;
  final _storage = LocalStorage();
  static const String _userTypeKey = 'user_type';

  void getUserState(UserType user) {
    userType = user;

    _storage.writeValue(_userTypeKey, user.name);

    if (user == UserType.CompanyUser) {
      emit(CompanyUserState());
    } else if (user == UserType.ConsultantUser) {
      emit(ConsultantUserState());
    } else if (user == UserType.StudentUser) {
      emit(StudentUserState());
    } else if (user == UserType.AccountingClintUser) {
      emit(AccountingClintUserState());
    } else {
      emit(VisitorUserState());
    }
  }

  void loadUserStateFromStorage() {
    final savedUserType = _storage.readValue<String>(_userTypeKey);

    if (savedUserType == UserType.CompanyUser.name) {
      getUserState(UserType.CompanyUser);
    } else if (savedUserType == UserType.ConsultantUser.name) {
      getUserState(UserType.ConsultantUser);
    } else if (savedUserType == UserType.StudentUser.name) {
      getUserState(UserType.StudentUser);
    } else if (savedUserType == UserType.AccountingClintUser.name) {
      getUserState(UserType.AccountingClintUser);
    } else {
      getUserState(UserType.VisitorUser); // افتراضي
    }
  }
}

enum UserType { VisitorUser, CompanyUser, ConsultantUser, StudentUser, AccountingClintUser }
