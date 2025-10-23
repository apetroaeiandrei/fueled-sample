import 'package:code_test_flutter/data/api/entities/photo_api_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:code_test_flutter/core/load_state.dart';

part 'home_contract.freezed.dart';

@freezed
abstract class HomeEvent with _$HomeEvent {
  const factory HomeEvent.init() = Init;
}

///
/// ViewState for the Screen's view state
///
@freezed
abstract class HomeData with _$HomeData {
  factory HomeData({
    @Default(LoadState.empty) LoadState loadState,
    String? errorMessage,
    @Default(<PhotoApiModel>[]) List<PhotoApiModel> photos,
  }) = _HomeData;
}