import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_test_flutter/data/api/entities/photo_api_model.dart';
import 'package:code_test_flutter/data/api/photos_api.dart';
import 'package:code_test_flutter/screens/home/home_contract.dart';
import 'package:code_test_flutter/core/load_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeData> {
  final PhotosApi _api;

  HomeBloc(this._api) : super(HomeData()) {
    on<Init>(_onInit);
    on<Refresh>(_onRefresh);
  }

  Future<void> _onInit(Init event, Emitter<HomeData> emit) async {
    final List<PhotoApiModel> photos = await _api.getPhotos().call;
    emit(state.copyWith(loadState: LoadState.data, photos: photos));
  }

  Future<void> _onRefresh(Refresh event, Emitter<HomeData> emit) async {
    final List<PhotoApiModel> photos = await _api.getPhotos().call;
    emit(state.copyWith(loadState: LoadState.data, photos: photos));
  }
}
