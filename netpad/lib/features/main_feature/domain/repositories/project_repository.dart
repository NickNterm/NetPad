import 'package:dartz/dartz.dart';
import 'package:netpad/core/failure/failure.dart';
import 'package:netpad/features/main_feature/data/models/project_model.dart';
import 'package:netpad/features/main_feature/domain/entities/project.dart';

abstract class ProjectRepository {
  Future<Either<Failure, ProjectModel>> createProject(Project project);
  Future<Either<Failure, int>> deleteProject(Project project);
  Future<Either<Failure, List<Project>>> getProjects();
  Future<Either<Failure, ProjectModel>> editProject(Project project);
  Future<Either<Failure, bool>> generateProjectPDF(int id);
}
