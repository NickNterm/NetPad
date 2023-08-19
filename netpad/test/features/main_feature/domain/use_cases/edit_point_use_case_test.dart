import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:netpad/features/main_feature/data/models/point_data_model.dart';
import 'package:netpad/features/main_feature/domain/repositories/point_repository.dart';
import 'package:netpad/features/main_feature/domain/use_cases/edit_point_use_case.dart';

class MockPointRepository extends Mock implements PointRepository {}

void main() {
  late MockPointRepository mockPointRepository;
  late EditPointUseCase editPointUseCase;

  setUp(() {
    mockPointRepository = MockPointRepository();
    editPointUseCase = EditPointUseCase(mockPointRepository);
  });

  test("should return true when edit point", () async {
    // arrange
    when(() => mockPointRepository.editPoint(PointDataModel.def()))
        .thenAnswer((_) async => Right(PointDataModel.def()));
    // act
    final result = await editPointUseCase(PointDataModel.def());
    // assert
    expect(result, Right(PointDataModel.def()));
    verify(() => mockPointRepository.editPoint(PointDataModel.def()));
    verifyNoMoreInteractions(mockPointRepository);
  });
}
