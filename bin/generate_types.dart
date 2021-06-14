import 'dart:io';

import 'package:more/iterable.dart';

/// Number of tuples to generate (exclusive).
const int max = 11;

/// Root directory of paths.
File getFile(String name) => File('lib/src/functional/types/$name.dart');

/// Pretty prints and cleans up a dart file.
Future<void> format(File file) async =>
    Process.run('dart', ['format', '--fix', file.absolute.path]);

/// Generate type names.
List<String> generateTypes(int i) => List.generate(i, (i) => 'T$i');

/// Generate argument names.
List<String> generateArgs(int i) => List.generate(i, (i) => 'arg$i');

/// Generate type and argument names.
List<String> generateTypeAndArgs(int i) => [generateTypes(i), generateArgs(i)]
    .zip()
    .map((elements) => elements.join(' '))
    .toList();

/// Creates an argument list from types or variables.
String listify(Iterable<String> values) => values.join(', ');

/// Wraps a list of types in generics brackets.
String generify(Iterable<String> types) =>
    types.isEmpty ? '' : '<${listify(types)}>';

Future<void> generateCallback() async {
  final file = getFile('callback');
  final out = file.openWrite();

  out.writeln('/// Function types for generic callbacks.');
  out.writeln();

  for (var i = 0; i < max; i++) {
    out.writeln('/// Function callback with $i argument${i == 1 ? '' : 's'}.');
    out.writeln('typedef Callback$i${generify(generateTypes(i))} = '
        'void Function(${listify(generateTypeAndArgs(i))});');
    out.writeln();
  }

  await out.close();
  await format(file);
}

Future<void> generateMapping() async {
  final file = getFile('mapping');
  final out = file.openWrite();

  out.writeln('/// Function type for generic mapping functions.');
  out.writeln();

  for (var i = 0; i < max; i++) {
    out.writeln('/// Function callback with $i argument${i == 1 ? '' : 's'}.');
    out.writeln('typedef Map$i${generify([...generateTypes(i), 'R'])} = '
        'R Function(${listify(generateTypeAndArgs(i))});');
    out.writeln();
  }

  await out.close();
  await format(file);
}

Future<void> generatePredicate() async {
  final file = getFile('predicate');
  final out = file.openWrite();

  out.writeln('/// Function type for generic predicate functions.');
  out.writeln();

  for (var i = 0; i < max; i++) {
    out.writeln('/// Function predicate with $i argument${i == 1 ? '' : 's'}.');
    out.writeln('typedef Predicate$i${generify(generateTypes(i))} = '
        'bool Function(${listify(generateTypeAndArgs(i))});');
    out.writeln();
  }

  await out.close();
  await format(file);
}

Future<void> generateEmpty() async {
  final file = getFile('empty');
  final out = file.openWrite();

  out.writeln('/// Generic empty functions returning nothing.');
  out.writeln();

  for (var i = 0; i < max; i++) {
    out.writeln('/// Empty function with $i argument${i == 1 ? '' : 's'}.');
    out.writeln('void emptyFunction$i${generify(generateTypes(i))} '
        '(${listify(generateTypeAndArgs(i))}) {}');
    out.writeln();
  }

  await out.close();
  await format(file);
}

Future<void> generateIdentity() async {
  final file = getFile('identity');
  final out = file.openWrite();

  out.writeln('/// Generic identity functions.');
  out.writeln();

  out.writeln('/// Canonical identity function with 1 argument.');
  out.writeln('T identityFunction<T>(T arg) => arg;');
  out.writeln();

  await out.close();
  await format(file);
}

Future<void> generateConstant() async {
  final file = getFile('constant');
  final out = file.openWrite();

  out.writeln('/// The constant functions.');
  out.writeln("import 'mapping.dart';");
  out.writeln();

  for (var i = 0; i < max; i++) {
    final prefix = '$i${generify([...generateTypes(i), 'R'])}';
    out.writeln('/// Constant function with $i argument${i == 1 ? '' : 's'}.');
    out.writeln('Map$prefix constantFunction$prefix(R value) '
        '=> (${listify(generateArgs(i))}) '
        '=> value;');
    out.writeln();
  }

  await out.close();
  await format(file);
}

Future<void> generateThrowing() async {
  final file = getFile('throwing');
  final out = file.openWrite();

  out.writeln('// ignore_for_file: only_throw_errors');
  out.writeln();

  out.writeln('/// The throwing functions.');
  out.writeln("import 'mapping.dart';");
  out.writeln();

  for (var i = 0; i < max; i++) {
    final prefix = '$i${generify([...generateTypes(i), 'R'])}';
    out.writeln('/// Throwing function with $i argument${i == 1 ? '' : 's'}.');
    out.writeln('Map$prefix throwFunction$prefix(Object throwable) '
        '=> (${listify(generateArgs(i))}) '
        '=> throw throwable;');
    out.writeln();
  }

  await out.close();
  await format(file);
}

Future<void> main() async {
  await generateCallback();
  await generateMapping();
  await generatePredicate();
  await generateEmpty();
  await generateIdentity();
  await generateConstant();
  await generateThrowing();
}
