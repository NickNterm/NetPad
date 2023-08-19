import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:netpad/features/main_feature/data/models/point_data_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockPointDataModel extends Mock implements PointDataModel {}

void main() {
  late MockPointDataModel mockPointDataModel;
  PointDataModel tPointDataModel = PointDataModel.def();

  setUp(() {
    mockPointDataModel = MockPointDataModel();
  });

  test('should be a subclass of PointData entity', () async {
    // assert
    expect(mockPointDataModel, isA<PointDataModel>());
  });

  test('should return PointDataModel', () async {
    // arrange
    final Map<String, dynamic> jsonMap = jsonDecode(
      fixture('point_data_json.json'),
    );
    // act
    final result = PointDataModel.fromJson(jsonMap);
    // assert
    expect(result, tPointDataModel);
  });

  test('the json should be the same the toJson result', () async {
    // arrange
    final Map<String, dynamic> jsonMap = jsonDecode(
      fixture('point_data_json.json'),
    );
    // act
    final result = jsonDecode(tPointDataModel.toJson());
    // assert
    expect(jsonMap, result);
  });
}
