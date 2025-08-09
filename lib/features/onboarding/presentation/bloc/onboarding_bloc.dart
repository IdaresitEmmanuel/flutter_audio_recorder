import 'package:audiorecorder/core/resources/data_state.dart';
import 'package:audiorecorder/features/onboarding/domain/usecases/get_onboarding_status.dart';
import 'package:audiorecorder/features/onboarding/domain/usecases/set_onboarding_status.dart';
import 'package:audiorecorder/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:audiorecorder/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final GetOnboardingStatusUseCase _getOnboardingStatusUseCase;
  final SetOnboardingStatusUseCase _setOnboardingStatusUseCase;
  OnboardingBloc(
    this._getOnboardingStatusUseCase,
    this._setOnboardingStatusUseCase,
  ) : super(const OnboardingLoading()) {
    on<GetOnboardingStatus>(onGetOnboardingStatus);
    on<SetOnboardingStatus>(onSetOnboardingStatus);
  }

  void onGetOnboardingStatus(
    GetOnboardingStatus event,
    Emitter<OnboardingState> emit,
  ) async {
    final dataState = await _getOnboardingStatusUseCase();

    if (dataState is DataSuccess && dataState.data != null) {
      emit(OnboardingDone(dataState.data!));
    }

    if (dataState is DataFailure && dataState.error != null) {
      emit(OnboardingError(dataState.error!));
    }
  }

  void onSetOnboardingStatus(
    SetOnboardingStatus event,
    Emitter<OnboardingState> emit,
  ) async {
    await _setOnboardingStatusUseCase();
  }
}
