import 'package:dartz/dartz.dart';
import 'package:netpad/core/failure/failure.dart';
import 'package:netpad/features/main_feature/domain/entities/point_data.dart';
import 'package:netpad/features/main_feature/domain/repositories/point_repository.dart';

class GetPointsUseCase {
  final PointRepository pointRepository;

  GetPointsUseCase(this.pointRepository);

  Future<Either<Failure, List<PointData>>> call() async {
    return await pointRepository.getPoints();
  }
}
