import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/Util/page_router.dart';
import 'package:flutter_task/Util/palette.dart';
import 'package:flutter_task/Util/sizing.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final nav = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.init((await getApplicationDocumentsDirectory()).path);
  await Hive.openBox('appData');
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          Sizing().init(constraints, orientation);
          return MaterialApp(
            theme: ThemeData.light().copyWith(
              primaryColor: primaryColor,
              scaffoldBackgroundColor: Colors.white,
            ),
            navigatorKey: nav,
            debugShowCheckedModeBanner: false,
            initialRoute: PageRouter.splash,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        });
      },
    );
  }
}
