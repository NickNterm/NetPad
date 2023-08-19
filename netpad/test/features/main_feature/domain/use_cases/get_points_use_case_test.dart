import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:netpad/features/main_feature/data/models/point_data_model.dart';
import 'package:netpad/features/main_feature/domain/entities/point_data.dart';
import 'package:netpad/features/main_feature/domain/repositories/point_repository.dart';
import 'package:netpad/features/main_feature/domain/use_cases/get_points_use_case.dart';

class MockPointRepository extends Mock implements PointRepository {}

void main() {
  late MockPointRepository mockPointRepository;
  late GetPointsUseCase getPointsUseCase;

  setUp(() {
    mockPointRepository = MockPointRepository();
    getPointsUseCase = GetPointsUseCase(mockPointRepository);
  });

  test('should return list of points when get points', () async {
    List<PointData> points = <PointData>[PointDataModel.def()];
    // arrange
    when(() => mockPointRepository.getPoints())
        .thenAnswer((_) async => Right(points));
    // act
    final result = await getPointsUseCase();
    // assert
    expect(result, Right(points));
    verify(() => mockPointRepository.getPoints());
    verifyNoMoreInteractions(mockPointRepository);
  });
}
