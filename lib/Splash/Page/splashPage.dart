import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_network_connectivity/flutter_network_connectivity.dart';
import 'package:flutter_task/Util/hive_helper.dart';
import 'package:flutter_task/Util/page_router.dart';
import 'package:flutter_task/Util/palette.dart';
import 'package:flutter_task/Util/sizing.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String currentIP = '';
  Position? _currentPosition;
  String _currentAddress = '';
  String postalCode = '';
  bool isDataFetched = false;
  @override
  void initState() {
    super.initState();
    checkConnectivity();
    getIpInfo();
  }

  checkConnectivity() async {
    //check location enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
    }
    //check network enabled
    bool isNetworkConnected =
        await FlutterNetworkConnectivity().isNetworkConnectionAvailable();
    if (!isNetworkConnected) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Mobile network are disabled. Please enable the services')));
    }
  }

  getIpInfo() async {
    try {
      var list = await NetworkInterface.list(
          includeLoopback: true, type: InternetAddressType.IPv4);
      currentIP = list[0].addresses[0].address;

      // final hasPermission = await Geolocator.isLocationServiceEnabled();
      final hasPermission = await _handleLocationPermission();
      if (hasPermission) {
        await getCurrentPosition();
        await placemarkFromCoordinates(
                _currentPosition!.latitude, _currentPosition!.longitude)
            .then((List<Placemark> placemarks) {
          Placemark place = placemarks[0];
          _currentAddress = place.locality ?? '';
          postalCode = place.postalCode ?? '';
        });
      }

      HiveHelper().saveCurrentIP(currentIP);
      HiveHelper().saveCurrentLocation(_currentAddress);
      HiveHelper().saveCurrentPostalCode(postalCode);

      bool loginStatus = HiveHelper().getLoginStatus();
      if (loginStatus) {
        Navigator.of(context).pushReplacementNamed(
          PageRouter.dashboardPage,
        );
      } else {
        Navigator.of(context).pushReplacementNamed(
          PageRouter.loginPage,
        );
      }
    } on Exception catch (e) {
      rethrow;
    }
  }

  getCurrentPosition() async {
    try {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        setState(() => _currentPosition = position);
      });
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: primaryColor,
          body: Center(
            child: SizedBox(
              height: Sizing.height(200, 100),
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1.2),
                duration: const Duration(seconds: 3),
                builder: (BuildContext context, double _val, child) {
                  return Transform.scale(
                    scale: _val,
                    child: child,
                  );
                },
                child: Center(
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                        color: whiteColor, fontSize: Sizing.height(15, 20)),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
