import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:netpad/features/main_feature/data/models/project_model.dart';
import 'package:netpad/features/main_feature/domain/repositories/project_repository.dart';
import 'package:netpad/features/main_feature/domain/use_cases/edit_project_use_case.dart';

class MockProjectRepository extends Mock implements ProjectRepository {}

void main() {
  late MockProjectRepository mockProjectRepository;
  late EditProjectUseCase editProjectUseCase;

  setUp(() {
    mockProjectRepository = MockProjectRepository();
    editProjectUseCase = EditProjectUseCase(mockProjectRepository);
  });

  test('should return true when edit project', () async {
    // arrange
    when(() => mockProjectRepository.editProject(ProjectModel.def()))
        .thenAnswer((_) async => Right(ProjectModel.def()));
    // act
    final result = await editProjectUseCase(ProjectModel.def());
    // assert
    expect(result, Right(ProjectModel.def()));
    verify(() => mockProjectRepository.editProject(ProjectModel.def()));
    verifyNoMoreInteractions(mockProjectRepository);
  });
}
