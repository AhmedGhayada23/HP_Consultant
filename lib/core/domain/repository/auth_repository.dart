import 'package:flutter/material.dart';
import 'package:hb/core/data/datasource/auth_remote_data_source.dart';
import 'package:hb/core/data/models/consultant_register_model.dart';
import 'package:hb/core/data/models/register_model.dart';

abstract class AuthRepository {
  Future<String> login({
    required BuildContext context,
    required String email,
    required String password,
  });
  Future<void> register({required BuildContext context, required RegisterModel registerModel});
  Future<void> registerConsultant({required BuildContext context, required ConsultantRegisterModel model});
  Future<void> sendActivationCode({required BuildContext context, required String email, required String type});
  Future<void> chackActivationCode({
    required BuildContext context,
    required String email,
    required String code,
    required String type,
  });
  Future<void> forgetPasswordSendCode({required BuildContext context, required String email});
  Future<void> forgetPasswordChackCode({
    required BuildContext context,
    required String email,
    required String code,
  });
  Future<void> forgetResetPassword({
    required BuildContext context,
    required String email,
    required String newPassword,
    required String confirmPassword,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> login({
    required BuildContext context,
    required String email,
    required String password,
  }) {
    return remoteDataSource.login(context: context, email: email, password: password);
  }

  @override
  Future<void> register({required BuildContext context, required RegisterModel registerModel}) {
    return remoteDataSource.register(context: context, registerModel: registerModel);
  }

  @override
  Future<void> registerConsultant({required BuildContext context, required ConsultantRegisterModel model}) {
    return remoteDataSource.registerConsultant(context: context, model: model);
  }

  @override
  Future<void> sendActivationCode({required BuildContext context, required String email, required String type}) {
    return remoteDataSource.sendActivationCode(context: context, email: email, type: type);
  }

  @override
  Future<void> chackActivationCode({
    required BuildContext context,
    required String email,
    required String code,
    required String type,
  }) {
    return remoteDataSource.chackActivationCode(context: context, email: email, code: code, type: type);
  }

  @override
  Future<void> forgetPasswordSendCode({required BuildContext context, required String email}) {
    return remoteDataSource.forgetPasswordSendCode(context: context, email: email);
  }

  @override
  Future<void> forgetPasswordChackCode({
    required BuildContext context,
    required String email,
    required String code,
  }) {
    return remoteDataSource.forgetPasswordChackCode(context: context, email: email, code: code);
  }

  @override
  Future<void> forgetResetPassword({
    required BuildContext context,
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) {
    return remoteDataSource.forgetResetPassword(
      context: context,
      email: email,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}
