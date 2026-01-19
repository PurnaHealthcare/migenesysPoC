import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false; // Initially not subscribed
  }

  void subscribe() {
    state = true;
  }

  void unsubscribe() {
    state = false;
  }
}

final subscriptionProvider = NotifierProvider<SubscriptionNotifier, bool>(() {
  return SubscriptionNotifier();
});
