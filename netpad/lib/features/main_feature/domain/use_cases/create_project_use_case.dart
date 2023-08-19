import 'package:dartz/dartz.dart';
import 'package:netpad/core/failure/failure.dart';
import 'package:netpad/features/main_feature/domain/entities/project.dart';
import 'package:netpad/features/main_feature/domain/repositories/project_repository.dart';

class CreateProjectUseCase {
  final ProjectRepository projectRepository;

  CreateProjectUseCase(this.projectRepository);

  Future<Either<Failure, Project>> call(Project projectModel) async {
    return await projectRepository.createProject(projectModel);
  }
}
