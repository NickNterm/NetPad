import 'package:dartz/dartz.dart';
import 'package:netpad/core/failure/failure.dart';
import 'package:netpad/features/main_feature/data/local_data_source/main_local_data_source.dart';
import 'package:netpad/features/main_feature/data/models/point_data_model.dart';
import 'package:netpad/features/main_feature/data/models/project_model.dart';
import 'package:netpad/features/main_feature/domain/entities/point_data.dart';
import 'package:netpad/features/main_feature/domain/entities/project.dart';
import 'package:netpad/features/main_feature/domain/repositories/point_repository.dart';

class PointRepositoryImpl extends PointRepository {
  final MainLocalDataSource localDataSource;
  PointRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, PointDataModel>> createPoint(
    PointData point,
    Project project,
  ) async {
    try {
      var result = await localDataSource.createPoint(
        PointDataModel.fromEntity(point),
      );
      List<int> points = [];
      points.addAll(project.points);
      points.add(result.id);
      project = ProjectModel.fromEntity(project).copyWith(points: points);
      await localDataSource.editProject(ProjectModel.fromEntity(project));
      return Right(result);
    } catch (e) {
      return Left(SQLiteFailure());
    }
  }

  @override
  Future<Either<Failure, int>> deletePoint(int id, Project project) async {
    try {
      var result = await localDataSource.deletePoint(id);
      List<int> points = [];
      points.addAll(project.points);
      points.remove(id);
      await localDataSource.editProject(
        ProjectModel.fromEntity(project).copyWith(points: points),
      );
      return Right(result);
    } catch (e) {
      return Left(SQLiteFailure());
    }
  }

  @override
  Future<Either<Failure, PointDataModel>> editPoint(PointData point) async {
    try {
      var result = await localDataSource.editPoint(
        PointDataModel.fromEntity(point),
      );
      return Right(result);
    } catch (e) {
      return Left(SQLiteFailure());
    }
  }

  @override
  Future<Either<Failure, List<PointData>>> getPoints() async {
    try {
      var result = await localDataSource.getPoints();
      return Right(result);
    } catch (e) {
      return Left(SQLiteFailure());
    }
  }
}
