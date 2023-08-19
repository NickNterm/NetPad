part of 'project_bloc.dart';

@immutable
abstract class ProjectState {}

class ProjectLoaded extends ProjectState {
  final List<Project> projects;

  ProjectLoaded(this.projects);
}

class ProjectLoading extends ProjectState {}
