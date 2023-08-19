import 'package:dartz/dartz.dart';
import 'package:netpad/core/failure/failure.dart';
import 'package:netpad/features/main_feature/data/models/point_data_model.dart';
import 'package:netpad/features/main_feature/domain/entities/point_data.dart';
import 'package:netpad/features/main_feature/domain/entities/project.dart';

abstract class PointRepository {
  Future<Either<Failure, List<PointData>>> getPoints();
  Future<Either<Failure, PointDataModel>> createPoint(
    PointData point,
    Project project,
  );
  Future<Either<Failure, PointDataModel>> editPoint(PointData point);
  Future<Either<Failure, int>> deletePoint(int id, Project project);
}
