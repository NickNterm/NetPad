part of 'point_data_bloc.dart';

@immutable
abstract class PointDataState {}

class PointDataInitial extends PointDataState {}

class PointDataLoading extends PointDataState {}

class PointDataLoaded extends PointDataState {
  final List<PointData> pointDataList;

  PointDataLoaded(this.pointDataList);
}
