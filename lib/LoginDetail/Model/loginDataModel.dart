import 'package:cloud_firestore/cloud_firestore.dart';

class LoginData {
  final String? dateTime;
  final String? iPAddress;
  final String? address;
  final String qrData;

  const LoginData(
      {this.dateTime, this.iPAddress, this.address, required this.qrData});

  toJson() {
    return {
      "DateTime": dateTime,
      "IPAddress": iPAddress,
      "Address": address,
      "QrData": qrData
    };
  }

  factory LoginData.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return LoginData(
      dateTime: data!["DateTime"],
      iPAddress: data["IPAddress"],
      address: data["Address"],
      qrData: data["QrData"] ?? '',
    );
  }
}
