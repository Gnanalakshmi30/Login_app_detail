import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_task/LoginDetail/Model/loginDataModel.dart';

class LoginService {
  final auth = FirebaseFirestore.instance;
  updateLoginData(LoginData logindata) async {
    try {
      await auth.collection('Login_detail').add(logindata.toJson());
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<List<LoginData>> getLoginData() async {
    try {
      var res = await auth.collection('Login_detail').get();
      final loginData = res.docs.map((e) => LoginData.fromSnapshot(e)).toList();
      return loginData;
    } on Exception catch (e) {
      rethrow;
    }
  }
}
