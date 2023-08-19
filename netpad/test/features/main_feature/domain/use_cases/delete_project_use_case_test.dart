import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:netpad/features/main_feature/data/models/project_model.dart';
import 'package:netpad/features/main_feature/domain/entities/project.dart';
import 'package:netpad/features/main_feature/domain/repositories/project_repository.dart';
import 'package:netpad/features/main_feature/domain/use_cases/delete_project_use_case.dart';

class MockProjectRepository extends Mock implements ProjectRepository {}

class FakeProjectModel extends Fake implements Project {}

void main() {
  late MockProjectRepository mockProjectRepository;
  late DeleteProjectUseCase deleteProjectUseCase;

  setUp(() {
    registerFallbackValue(FakeProjectModel());
    mockProjectRepository = MockProjectRepository();
    deleteProjectUseCase = DeleteProjectUseCase(mockProjectRepository);
  });

  test('should return true when delete project', () async {
    // arrange
    when(() => mockProjectRepository.deleteProject(any()))
        .thenAnswer((_) async => const Right(0));
    // act
    final result = await deleteProjectUseCase(ProjectModel.def());
    // assert
    expect(result, const Right(0));
    verify(() => mockProjectRepository.deleteProject(ProjectModel.def()));
    verifyNoMoreInteractions(mockProjectRepository);
  });
}
