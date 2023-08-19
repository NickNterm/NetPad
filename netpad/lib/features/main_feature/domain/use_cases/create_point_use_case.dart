import 'package:dartz/dartz.dart';
import 'package:netpad/core/failure/failure.dart';
import 'package:netpad/features/main_feature/domain/entities/point_data.dart';
import 'package:netpad/features/main_feature/domain/entities/project.dart';
import 'package:netpad/features/main_feature/domain/repositories/point_repository.dart';

class CreatePointUseCase {
  CreatePointUseCase(this.repository);

  final PointRepository repository;

  Future<Either<Failure, PointData>> call(
    PointData point,
    Project project,
  ) async {
    return await repository.createPoint(
      point,
      project,
    );
  }
}
