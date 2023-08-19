import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:netpad/features/main_feature/data/models/project_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockProjectModel extends Mock implements ProjectModel {}

void main() {
  late MockProjectModel mockProjectModel;
  ProjectModel tProjectModel = ProjectModel.def();

  setUp(() {
    mockProjectModel = MockProjectModel();
  });

  test('should be a subclass of Project entity', () async {
    // assert
    expect(mockProjectModel, isA<ProjectModel>());
  });

  test('should return ProjectModel', () async {
    // arrange
    // act
    final result = ProjectModel.fromJson(
      jsonDecode(fixture('project_json.json')),
    );
    // assert
    expect(result, tProjectModel);
  });

  test('the json should be the same the toJson result', () async {
    // arrange
    final Map<String, dynamic> jsonMap = jsonDecode(
      fixture('project_json.json'),
    );
    // act
    final result = jsonDecode(tProjectModel.toJson());
    // assert
    expect(jsonMap, result);
  });
}
