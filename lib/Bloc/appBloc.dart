import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task/Bloc/appEvents.dart';
import 'package:flutter_task/Bloc/appState.dart';
import 'package:flutter_task/LoginDetail/Model/loginDataModel.dart';
import 'package:flutter_task/LoginDetail/Service/loginDataService.dart';

class LoginDataBloc extends Bloc<LoginDataEvent, LoginDataState> {
  final LoginService loginDataService;

  LoginDataBloc({required this.loginDataService}) : super(InitialState()) {
    List<LoginData> loginInfo = [];
    on<LoadLoginData>((event, emit) async {
      emit(LoginDataAdding());
      try {
        loginInfo = await loginDataService.getLoginData();
        emit(LoginDataAdded(loginInfo));
      } catch (e) {
        emit(LoginDataError(e.toString()));
      }
    });

    on<Create>((event, emit) async {
      emit(LoginDataAdding());
      await Future.delayed(Duration(seconds: 1));

      try {
        await loginDataService.updateLoginData(event.loginDataModel);
        emit(LoginDataAdded(loginInfo));
      } catch (e) {
        emit(LoginDataError(e.toString()));
      }
    });
  }
}
