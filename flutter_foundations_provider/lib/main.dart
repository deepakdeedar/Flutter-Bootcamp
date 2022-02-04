import 'package:flutter/material.dart';
import 'package:flutter_foundations_provider/randomizer_change_notifier.dart';
import 'package:flutter_foundations_provider/range_selector_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RandomizerChangeNotifier(),
      child: MaterialApp(
        title: 'Randonizer',
        home: RangeSelectorPage(),
      ),
    );
  }
}
