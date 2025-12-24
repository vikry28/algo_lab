// ignore_for_file: avoid_print

import 'dart:io';

void main(List<String> args) async {
  if (args.isEmpty) {
    print("Usage:");
    print("  dart run cli.dart make:feature feature_name");
    print("  dart run cli.dart make:usecase usecase_name");
    print("  dart run cli.dart make:model model_name");
    print("  dart run cli.dart make:provider provider_name");
    exit(0);
  }

  final command = args[0];
  final name = args.length > 1 ? args[1] : '';

  switch (command) {
    case 'make:feature':
      await _makeFeature(name);
      break;
    case 'make:usecase':
      await _makeUseCase(name);
      break;
    case 'make:model':
      await _makeModel(name);
      break;
    case 'make:provider':
      await _makeProvider(name);
      break;
    case 'make:datasource':
      await _makeDatasource(name);
      break;
    default:
      print("Unknown command: $command");
  }
}

/// Create folder structure for a feature
Future<void> _makeFeature(String feature) async {
  if (feature.isEmpty) {
    print("Please provide feature name");
    return;
  }

  final base = "lib/features/$feature";

  final dirs = [
    "$base/data/datasources",
    "$base/data/models",
    "$base/data/repository",
    "$base/domain/entities",
    "$base/domain/repository",
    "$base/domain/usecases",
    "$base/presentation/view",
    "$base/presentation/provider",
    "$base/presentation/widget",
  ];

  for (var dir in dirs) {
    await Directory(dir).create(recursive: true);
  }

  print("Feature '$feature' created successfully!");
}

/// Create usecase file
Future<void> _makeUseCase(String name) async {
  if (name.isEmpty) return;

  final path =
      "lib/features/${_snakeToCamel(name)}/domain/usecases/${name}_usecase.dart";

  final file = File(path);
  await file.create(recursive: true);

  await file.writeAsString("""
class ${_pascal(name)}UseCase {
  // TODO: implement business logic
  Future<void> call() async {}
}
""");

  print("UseCase '$name' created!");
}

/// Create model file
Future<void> _makeModel(String name) async {
  if (name.isEmpty) return;

  final path =
      "lib/features/${_snakeToCamel(name)}/data/models/${name}_model.dart";

  final file = File(path);
  await file.create(recursive: true);

  await file.writeAsString("""
class ${_pascal(name)}Model {
  // TODO: implement fields & fromJson
}
""");

  print("Model '$name' created!");
}

/// Create Provider
Future<void> _makeProvider(String name) async {
  if (name.isEmpty) return;

  final path =
      "lib/features/${_snakeToCamel(name)}/presentation/provider/${name}_provider.dart";

  final file = File(path);
  await file.create(recursive: true);

  await file.writeAsString("""
import 'package:flutter/material.dart';

class ${_pascal(name)}Provider extends ChangeNotifier {
  // TODO: implement state management
}
""");

  print("Provider '$name' created!");
}

/// Create datasource
Future<void> _makeDatasource(String name) async {
  if (name.isEmpty) return;

  final path =
      "lib/features/${_snakeToCamel(name)}/data/datasources/${name}_datasource.dart";

  final file = File(path);
  await file.create(recursive: true);

  await file.writeAsString("""
class ${_pascal(name)}DataSource {
  // TODO: implement API / local DB calls
}
""");

  print("Datasource '$name' created!");
}

/// Helpers
String _pascal(String text) =>
    text.split('_').map((e) => e[0].toUpperCase() + e.substring(1)).join();

String _snakeToCamel(String text) => text.toLowerCase();
