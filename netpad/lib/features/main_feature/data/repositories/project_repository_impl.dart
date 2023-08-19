import 'package:dartz/dartz.dart';
import 'package:netpad/core/failure/failure.dart';
import 'package:netpad/features/main_feature/data/local_data_source/main_local_data_source.dart';
import 'package:netpad/features/main_feature/data/models/project_model.dart';
import 'package:netpad/features/main_feature/domain/entities/project.dart';
import 'package:netpad/features/main_feature/domain/repositories/project_repository.dart';

class ProjectRepositoryImpl extends ProjectRepository {
  final MainLocalDataSource localDataSource;
  ProjectRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, ProjectModel>> createProject(Project project) async {
    try {
      var result =
          await localDataSource.createProject(ProjectModel.fromEntity(project));
      return Right(result);
    } catch (e) {
      return Left(SQLiteFailure());
    }
  }

  @override
  Future<Either<Failure, int>> deleteProject(Project project) async {
    try {
      var result = await localDataSource.deleteProject(project.id);
      for (var point in project.points) {
        await localDataSource.deletePoint(point);
      }
      return Right(result);
    } catch (e) {
      return Left(SQLiteFailure());
    }
  }

  @override
  Future<Either<Failure, ProjectModel>> editProject(Project project) async {
    try {
      var result = await localDataSource.editProject(project as ProjectModel);
      return Right(result);
    } catch (e) {
      return Left(SQLiteFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> generateProjectPDF(int id) async {
    try {
      var result = await localDataSource.generateProjectPDF(id);
      return Right(result);
    } catch (e) {
      return Left(SQLiteFailure());
    }
  }

  @override
  Future<Either<Failure, List<Project>>> getProjects() async {
    try {
      var result = await localDataSource.getProjects();
      return Right(result);
    } catch (e) {
      return Left(SQLiteFailure());
    }
  }
}
