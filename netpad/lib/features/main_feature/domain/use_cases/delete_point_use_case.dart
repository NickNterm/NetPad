import 'package:dartz/dartz.dart';
import 'package:netpad/core/failure/failure.dart';
import 'package:netpad/features/main_feature/domain/entities/project.dart';
import 'package:netpad/features/main_feature/domain/repositories/point_repository.dart';

class DeletePointUseCase {
  DeletePointUseCase(this._repository);

  final PointRepository _repository;

  Future<Either<Failure, int>> call(int pointId, Project project) async {
    return await _repository.deletePoint(pointId, project);
  }
}
