import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:netpad/features/main_feature/data/models/project_model.dart';
import 'package:netpad/features/main_feature/domain/repositories/project_repository.dart';
import 'package:netpad/features/main_feature/domain/use_cases/create_project_use_case.dart';

class MockProjectRepository extends Mock implements ProjectRepository {}

void main() {
  late MockProjectRepository mockProjectRepository;
  late CreateProjectUseCase createProjectUseCase;

  setUp(() {
    mockProjectRepository = MockProjectRepository();
    createProjectUseCase = CreateProjectUseCase(mockProjectRepository);
  });

  test('should return true when create project', () async {
    // arrange
    when(() => mockProjectRepository.createProject(ProjectModel.def()))
        .thenAnswer((_) async => Right(ProjectModel.def()));
    // act
    final result = await createProjectUseCase(ProjectModel.def());
    // assert
    expect(result, Right(ProjectModel.def()));
    verify(() => mockProjectRepository.createProject(ProjectModel.def()));
    verifyNoMoreInteractions(mockProjectRepository);
  });
}
