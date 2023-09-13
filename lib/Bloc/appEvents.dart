import 'package:equatable/equatable.dart';
import 'package:flutter_task/LoginDetail/Model/loginDataModel.dart';

abstract class LoginDataEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadLoginData extends LoginDataEvent {
  @override
  List<Object?> get props => [];
}

class Create extends LoginDataEvent {
  final LoginData loginDataModel;

  Create(this.loginDataModel);
}
