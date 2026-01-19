import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllergiesNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    return [];
  }

  void addAllergy(String allergy) {
    if (!state.contains(allergy)) {
      state = [...state, allergy];
    }
  }

  void removeAllergy(String allergy) {
    state = state.where((item) => item != allergy).toList();
  }
}

final allergiesProvider = NotifierProvider<AllergiesNotifier, List<String>>(() {
  return AllergiesNotifier();
});
