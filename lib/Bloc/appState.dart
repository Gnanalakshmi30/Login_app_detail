import 'package:equatable/equatable.dart';
import 'package:flutter_task/LoginDetail/Model/loginDataModel.dart';

abstract class LoginDataState extends Equatable {}

class InitialState extends LoginDataState {
  @override
  List<Object?> get props => [];
}

class LoginDataAdding extends LoginDataState {
  @override
  List<Object?> get props => [];
}

class LoginDataAdded extends LoginDataState {
  final List<LoginData> list;
  LoginDataAdded(this.list);
  @override
  List<Object?> get props => [];
}

class LoginDataError extends LoginDataState {
  final String error;

  LoginDataError(this.error);
  @override
  List<Object?> get props => [error];
}
