import 'dart:async';

import 'package:code_test_flutter/screens/home/home_bloc.dart';
import 'package:code_test_flutter/screens/home/home_contract.dart';
import 'package:code_test_flutter/data/api/entities/common.dart';
import 'package:code_test_flutter/data/api/photos_api.dart';
import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../data/photo_fakes.dart';
@GenerateNiceMocks([
  MockSpec<PhotosApi>(),
])
import 'home_bloc_test.mocks.dart';

void main() {
  final initState = HomeData();
  final photos = [photoApiModel];

  late MockPhotosApi service;

  void init() {
    resetMockitoState();
    service = MockPhotosApi();
  }

  // This function ensures init is called before every test runs.
  setUp(init);
  group('initialization', () {
    test('emits photos when initialized and service provides data', () async {
      when(service.getPhotos())
          .thenAnswer((_) => Cancellable(Future.value(photos), CancelToken()));

      final bloc = HomeBloc(service);

      final emittedStates = <HomeData>[];

      final subscription = bloc.stream.listen(emittedStates.add);

      expect(emittedStates, []);

      await subscription.cancel();
    });
  });
}
