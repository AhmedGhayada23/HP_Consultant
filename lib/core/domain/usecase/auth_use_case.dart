import 'package:flutter/material.dart';
import 'package:hb/core/data/models/consultant_register_model.dart';
import 'package:hb/core/data/models/register_model.dart';
import 'package:hb/core/domain/repository/auth_repository.dart';

class AuthUseCase {
  final AuthRepository repository;
  const AuthUseCase(this.repository);

  Future<String> login({
    required BuildContext context,
    required String email,
    required String password,
  }) {
    return repository.login(context: context, email: email, password: password);
  }

  Future<void> register({required BuildContext context, required RegisterModel registerModel}) {
    return repository.register(context: context, registerModel: registerModel);
  }

  Future<void> registerConsultant({required BuildContext context, required ConsultantRegisterModel model}) {
    return repository.registerConsultant(context: context, model: model);
  }

  Future<void> sendActivationCode({required BuildContext context, required String email, required String type}) {
    return repository.sendActivationCode(context: context, email: email, type: type);
  }

  Future<void> chackActivationCode({
    required BuildContext context,
    required String email,
    required String code,
    required String type,
  }) {
    return repository.chackActivationCode(context: context, email: email, code: code, type: type);
  }

  Future<void> forgetPasswordSendCode({required BuildContext context, required String email}) {
    return repository.forgetPasswordSendCode(context: context, email: email);
  }

  Future<void> forgetPasswordChackCode({
    required BuildContext context,
    required String email,
    required String code,
  }) {
    return repository.forgetPasswordChackCode(context: context, email: email, code: code);
  }

  Future<void> forgetResetPassword({
    required BuildContext context,
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) {
    return repository.forgetResetPassword(
      context: context,
      email: email,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}
