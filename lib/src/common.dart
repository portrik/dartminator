import 'dart:convert';
import 'dart:io';

import 'generated/main.pb.dart';

const coordFactor = 1e7;

final List<Feature> featuresDb = _readDatabase();

List<Feature> _readDatabase() {
  final dbData = File('data/main_db.json').readAsStringSync();
  final List db = jsonDecode(dbData);

  return db.map((e) {
    final location = Point()
      ..latitude = e['location']['latitude']
      ..longitude = e['location']['longitude'];

    return Feature()
      ..name = e['name']
      ..location = location;
  }).toList();
}
