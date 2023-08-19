import 'package:dartz/dartz.dart';
import 'package:netpad/core/failure/failure.dart';
import 'package:netpad/features/main_feature/domain/entities/project.dart';
import 'package:netpad/features/main_feature/domain/repositories/project_repository.dart';

class DeleteProjectUseCase {
  final ProjectRepository projectRepository;

  DeleteProjectUseCase(this.projectRepository);

  Future<Either<Failure, int>> call(Project project) async {
    return await projectRepository.deleteProject(project);
  }
}
