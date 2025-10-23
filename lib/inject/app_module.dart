import 'package:code_test_flutter/data/api/photos_api.dart';
import 'package:code_test_flutter/data/api/unsplash_client.dart';
import 'package:dio/dio.dart';

class AppModule {
  static const baseUrl = 'https://api.unsplash.com/';
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
    ),
  );
  static final UnsplashClient client = UnsplashClient(dio);
  static final PhotosApi api = PhotosApi(client);
}
