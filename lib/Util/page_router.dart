import 'package:flutter/material.dart';
import 'package:flutter_task/Dashboard/dashboardPage.dart';
import 'package:flutter_task/Login/loginPage.dart';
import 'package:flutter_task/LoginDetail/Page/loginDetailPage.dart';
import 'package:flutter_task/Splash/Page/splashPage.dart';

class PageRouter {
  static const String splash = '/';
  static const String loginPage = '/loginPage';
  static const String dashboardPage = '/dashboardPage';
  static const String loginDtailPage = '/loginDtailPage';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case PageRouter.splash:
        return CustomPageRoute(
          child: const SplashPage(),
        );

      case PageRouter.loginPage:
        return CustomPageRoute(
          child: const LoginPage(),
        );

      case PageRouter.dashboardPage:
        return CustomPageRoute(
          child: const DashboardPage(),
        );

      case PageRouter.loginDtailPage:
        return CustomPageRoute(
          child: const LoginDetailPage(),
        );
      // case PageRouter.cartDtailPage:
      //   if (args is Map) {
      //     return CustomPageRoute(
      //         child: CartDetailPage(
      //       title: args['title'],
      //       price: args['price'],
      //       image: args['image'],
      //     ));
      //   } else {
      //     return _errorRoute();
      //   }

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) => const LoginPage());
  }
}

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  CustomPageRoute({required this.child})
      : super(
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) => child);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(animation),
        child: child,
      );
}
