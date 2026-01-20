import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migenesys_poc/app/app_life.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MiGenesysLifeApp(),
    ),
  );
}
