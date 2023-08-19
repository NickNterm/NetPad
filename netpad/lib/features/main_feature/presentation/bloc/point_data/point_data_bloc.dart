import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:netpad/features/main_feature/data/models/point_data_model.dart';
import 'package:netpad/features/main_feature/domain/entities/point_data.dart';
import 'package:netpad/features/main_feature/domain/entities/project.dart';
import 'package:netpad/features/main_feature/domain/use_cases/create_point_use_case.dart';
import 'package:netpad/features/main_feature/domain/use_cases/delete_point_use_case.dart';
import 'package:netpad/features/main_feature/domain/use_cases/edit_point_use_case.dart';
import 'package:netpad/features/main_feature/domain/use_cases/get_points_use_case.dart';
import 'package:netpad/features/main_feature/presentation/bloc/project/project_bloc.dart';
import 'package:netpad/injection/dependency_injection.dart';
part 'point_data_event.dart';
part 'point_data_state.dart';

class PointDataBloc extends Bloc<PointDataEvent, PointDataState> {
  final CreatePointUseCase createPointUseCase;
  final EditPointUseCase editPointUseCase;
  final DeletePointUseCase deletePointUseCase;
  final GetPointsUseCase getPointsUseCase;
  PointDataBloc({
    required this.createPointUseCase,
    required this.editPointUseCase,
    required this.deletePointUseCase,
    required this.getPointsUseCase,
  }) : super(PointDataLoaded(const [])) {
    on<PointDataEvent>((event, emit) async {
      if (event is CreatePointEvent) {
        List<PointData> points = (state as PointDataLoaded).pointDataList;
        emit(PointDataLoading());
        var result = await createPointUseCase(event.point, event.project);
        result.fold(
          (failure) => emit(PointDataLoaded(points)),
          (point) {
            sl<ProjectBloc>().add(GetProjectsEvent());
            emit(PointDataLoaded(points..add(point)));
          },
        );
      } else if (event is EditPointEvent) {
        List<PointData> points = (state as PointDataLoaded).pointDataList;
        emit(PointDataLoading());
        var result = await editPointUseCase(event.point as PointDataModel);
        result.fold(
          (failure) => emit(PointDataLoaded(points)),
          (point) => emit(
            PointDataLoaded(
              points
                ..removeWhere((element) => element.id == point.id)
                ..add(point),
            ),
          ),
        );
      } else if (event is DeletePointEvent) {
        List<PointData> points = (state as PointDataLoaded).pointDataList;
        emit(PointDataLoading());
        var result = await deletePointUseCase(event.id, event.project);
        result.fold(
          (failure) => emit(PointDataLoaded(points)),
          (id) => emit(
            PointDataLoaded(
              points..removeWhere((element) => element.id == id),
            ),
          ),
        );
      } else if (event is GetPointsEvent) {
        emit(PointDataLoading());
        var result = await getPointsUseCase();
        print(result);
        result.fold(
          (failure) => emit(PointDataLoaded(const [])),
          (points) => emit(PointDataLoaded(points)),
        );
      }
    });
  }
}
