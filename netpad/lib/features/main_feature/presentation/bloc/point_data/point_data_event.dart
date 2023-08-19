part of 'point_data_bloc.dart';

@immutable
abstract class PointDataEvent {}

class GetPointsEvent extends PointDataEvent {}

class CreatePointEvent extends PointDataEvent {
  final PointData point;
  final Project project;

  CreatePointEvent(this.point, this.project);
}

class EditPointEvent extends PointDataEvent {
  final PointData point;

  EditPointEvent(this.point);
}

class DeletePointEvent extends PointDataEvent {
  final int id;
  final Project project;

  DeletePointEvent(this.id, this.project);
}
