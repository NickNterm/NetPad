import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:netpad/features/main_feature/data/models/project_model.dart';
import 'package:netpad/features/main_feature/domain/entities/project.dart';
import 'package:netpad/features/main_feature/domain/repositories/project_repository.dart';
import 'package:netpad/features/main_feature/domain/use_cases/get_projects_use_case.dart';

class MockProjectRepository extends Mock implements ProjectRepository {}

void main() {
  late MockProjectRepository mockProjectRepository;
  late GetProjectsUseCase getProjectsUseCase;

  setUp(() {
    mockProjectRepository = MockProjectRepository();
    getProjectsUseCase = GetProjectsUseCase(mockProjectRepository);
  });

  test('should return list of projects', () async {
    List<Project> projects = <Project>[ProjectModel.def()];
    // arrange
    when(() => mockProjectRepository.getProjects())
        .thenAnswer((_) async => Right(projects));
    // act
    final result = await getProjectsUseCase();
    // assert
    expect(result, Right(projects));
    verify(() => mockProjectRepository.getProjects());
    verifyNoMoreInteractions(mockProjectRepository);
  });
}
