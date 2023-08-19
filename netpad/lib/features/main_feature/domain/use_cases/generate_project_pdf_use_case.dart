import 'package:dartz/dartz.dart';
import 'package:netpad/core/failure/failure.dart';
import 'package:netpad/features/main_feature/domain/repositories/project_repository.dart';

class GenerateProjectPDFUseCase {
  final ProjectRepository _repository;

  GenerateProjectPDFUseCase(this._repository);

  Future<Either<Failure, bool>> call(int projectId) async {
    return await _repository.generateProjectPDF(projectId);
  }
}
