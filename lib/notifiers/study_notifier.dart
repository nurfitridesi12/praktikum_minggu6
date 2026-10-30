import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/study_model.dart';

class StudyNotifier extends StateNotifier<StudyModel> {
  StudyNotifier()
      : super(StudyModel(
          subject: 'pemrograman mobile',
          currentProgress: 0,
          totalProgress: 5,
          isFavorite: false,
          focusMode: false,
        ));

  void incrementProgress() {
    if (state.currentProgress < state.totalProgress) {
      state = state.copyWith(currentProgress: state.currentProgress + 1);
    }
  }

  void decrementProgress() {
    if (state.currentProgress > 0) {
      state = state.copyWith(currentProgress: state.currentProgress - 1);
    }
  }

  void resetProgress() {
    state = state.copyWith(currentProgress: 0);
  }

  void resetAll() {
    state = StudyModel(
      subject: state.subject,
      currentProgress: 0,
      totalProgress: state.totalProgress,
      isFavorite: false,
      focusMode: false,
    );
  }

  void toggleFavorite() {
    state = state.copyWith(isFavorite: !state.isFavorite);
  }

  void toggleFocus() {
    state = state.copyWith(focusMode: !state.focusMode);
  }
}

final studyProvider =
    StateNotifierProvider<StudyNotifier, StudyModel>((ref) {
  return StudyNotifier();
});