import 'package:dartz/dartz.dart';
import 'package:netpad/core/failure/failure.dart';
import 'package:netpad/features/main_feature/data/models/point_data_model.dart';
import 'package:netpad/features/main_feature/domain/entities/point_data.dart';
import 'package:netpad/features/main_feature/domain/repositories/point_repository.dart';

class EditPointUseCase {
  final PointRepository repository;

  EditPointUseCase(this.repository);

  Future<Either<Failure, PointData>> call(PointDataModel point) async {
    return await repository.editPoint(point);
  }
}
