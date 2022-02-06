import 'package:flutter/material.dart';
import 'package:flutter_foundations_riverpod/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RandomizerPage extends ConsumerWidget {
  const RandomizerPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final randomizer = ref.read(randomizerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Randomizer'),
      ),
      body: Center(
        child: Text(
              randomizer.generatedNumber?.toString() ?? 'Generate a number',
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            )
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.read(randomizerProvider.notifier).generateNumber();
        },
        label: const Text('Generate'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
