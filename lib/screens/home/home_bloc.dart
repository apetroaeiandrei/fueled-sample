import 'dart:async';

import 'package:code_test_flutter/data/api/entities/photo_api_model.dart';
import 'package:code_test_flutter/data/api/photos_api.dart';
import 'package:code_test_flutter/screens/home/home_contract.dart';
import 'package:code_test_flutter/core/load_state.dart';

class HomeBloc {
  final _controller = StreamController<HomeData>.broadcast();

  Stream<HomeData> get stream => _controller.stream;
  HomeData _state = HomeData();
  final PhotosApi _api;

  HomeBloc(this._api);

  Future<void> initialize() async {
    final List<PhotoApiModel> photos = await _api.getPhotos().call;
    _state = _state.copyWith(
      loadState: LoadState.data,
      photos: photos,
    );
    _controller.sink.add(_state);
  }
}
