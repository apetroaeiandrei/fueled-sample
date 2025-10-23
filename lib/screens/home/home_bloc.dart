import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import 'package:code_test_flutter/data/api/entities/photo_api_model.dart';
import 'package:code_test_flutter/data/api/photos_api.dart';
import 'package:code_test_flutter/screens/home/home_contract.dart';
import 'package:code_test_flutter/core/load_state.dart';
import 'package:code_test_flutter/core/string_ids.dart';
import 'package:code_test_flutter/core/string_provider.dart';
import 'package:code_test_flutter/core/logging.dart';
import 'package:code_test_flutter/inject/app_injector.dart';

class HomeBloc extends Bloc<HomeEvent, HomeData> {
  final PhotosApi _api;
  final StringProvider _strings;

  HomeBloc(this._api)
      : _strings = getIt<StringProvider>(),
        super(HomeData()) {
    on<Init>(_onInit);
    on<Refresh>(_onRefresh);
  }

  Future<void> _onInit(Init event, Emitter<HomeData> emit) async {
    await _getPhotos(emit);
  }

  Future<void> _onRefresh(Refresh event, Emitter<HomeData> emit) async {
    await _getPhotos(emit);
  }

  Future<void> _getPhotos(Emitter<HomeData> emit) async {
    emit(state.copyWith(loadState: LoadState.loading));
    try {
      final List<PhotoApiModel> photos = await _api.getPhotos().call;
      emit(state.copyWith(
        loadState: LoadState.data,
        photos: photos,
        errorMessage: null,
      ));
    } catch (e, s) {
      final message = _mapErrorMessage(e);
      log(message: 'Failed to refresh photos', error: e, stackTrace: s);
      // Keep existing photos; just surface the error message
      emit(state.copyWith(
        loadState: LoadState.error,
        errorMessage: message,
      ));
    }
  }

  String _mapErrorMessage(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.cancel:
          return _strings.getString(StringId.requestCancelled);
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return _strings.getString(StringId.timeout);
        case DioExceptionType.connectionError:
          return _strings.getString(StringId.noNetwork);
        default:
          return _strings.getString(StringId.genericError);
      }
    }
    return _strings.getString(StringId.genericError);
  }
}
