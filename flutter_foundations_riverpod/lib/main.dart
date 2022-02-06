import 'package:flutter/material.dart';
import 'package:flutter_foundations_riverpod/randomizer_state_notifier.dart';
import 'package:flutter_foundations_riverpod/range_selector_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const AppWidget());
}

final randomizerProvider =
    StateNotifierProvider<RandomizerStateNotifier, RandomizerState>(
        (ref) => RandomizerStateNotifier());

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Randonizer',
        home: RangeSelectorPage(),
      ),
    );
  }
}
