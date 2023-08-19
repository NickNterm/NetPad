import 'package:dartz/dartz.dart';
import 'package:netpad/core/failure/failure.dart';
import 'package:netpad/features/main_feature/domain/entities/project.dart';
import 'package:netpad/features/main_feature/domain/repositories/project_repository.dart';

class EditProjectUseCase {
  final ProjectRepository _repository;
  EditProjectUseCase(this._repository);

  Future<Either<Failure, Project>> call(Project project) async {
    return await _repository.editProject(project);
  }
}
