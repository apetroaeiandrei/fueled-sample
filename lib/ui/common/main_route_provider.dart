import 'package:code_test_flutter/core/navigation/route_provider.dart';
import 'package:code_test_flutter/core/routes.dart';
import 'package:code_test_flutter/screens/home/home_screen.dart';
import 'package:code_test_flutter/screens/photo_detail/photo_detail_screen.dart';
import 'package:code_test_flutter/data/api/entities/photo_api_model.dart';

class MainRouteProvider extends RouteProvider {
  @override
  Iterable<(String, RouteBuilder)> routes() {
    return [
      (Routes.home, (context, params) => HomeScreen()),
      (
        Routes.photoDetailScreen,
        (context, params) =>
            PhotoDetailScreen(photo: params.data<PhotoApiModel>()),
      ),
    ];
  }
}
