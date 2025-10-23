import 'package:code_test_flutter/core/navigation/route_provider.dart';
import 'package:code_test_flutter/core/routes.dart';
import 'package:code_test_flutter/screens/home/home_screen.dart';

class MainRouteProvider extends RouteProvider {
  @override
  Iterable<(String, RouteBuilder)> routes() {
    return [
      (Routes.home, (context, params) => HomeScreen()),
    ];
  }
}
