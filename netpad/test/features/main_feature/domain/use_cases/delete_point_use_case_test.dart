import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:netpad/features/main_feature/domain/entities/project.dart';
import 'package:netpad/features/main_feature/domain/repositories/point_repository.dart';
import 'package:netpad/features/main_feature/domain/use_cases/delete_point_use_case.dart';

class MockPointRepository extends Mock implements PointRepository {}

class FakeProjectModel extends Fake implements Project {}

void main() {
  late MockPointRepository mockPointRepository;
  late DeletePointUseCase deletePointUseCase;

  setUp(() {
    registerFallbackValue(FakeProjectModel());
    mockPointRepository = MockPointRepository();
    deletePointUseCase = DeletePointUseCase(mockPointRepository);
  });

  test('should return true when delete point', () async {
    // arrange
    when(() => mockPointRepository.deletePoint(any(), any()))
        .thenAnswer((_) async => const Right(1));
    // act
    final result = await deletePointUseCase(1, FakeProjectModel());
    // assert
    expect(result, const Right(1));
    verify(() => mockPointRepository.deletePoint(1, any()));
    verifyNoMoreInteractions(mockPointRepository);
  });
}
