import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:netpad/features/main_feature/data/models/point_data_model.dart';
import 'package:netpad/features/main_feature/data/models/project_model.dart';
import 'package:netpad/features/main_feature/domain/repositories/point_repository.dart';
import 'package:netpad/features/main_feature/domain/use_cases/create_point_use_case.dart';

class MockPointRepository extends Mock implements PointRepository {}

void main() {
  late CreatePointUseCase createPointUseCase;
  late MockPointRepository mockPointRepository;

  setUp(() {
    mockPointRepository = MockPointRepository();
    createPointUseCase = CreatePointUseCase(mockPointRepository);
  });

  test('should return true when create point', () async {
    // arrange
    when(() => mockPointRepository.createPoint(
          PointDataModel.def(),
          ProjectModel.def(),
        )).thenAnswer((_) async => Right(PointDataModel.def()));
    // act
    final result = await createPointUseCase(
      PointDataModel.def(),
      ProjectModel.def(),
    );
    // assert
    expect(result, Right(PointDataModel.def()));
    verify(
      () => mockPointRepository.createPoint(
        PointDataModel.def(),
        ProjectModel.def(),
      ),
    );
    verifyNoMoreInteractions(mockPointRepository);
  });
}
