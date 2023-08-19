part of 'project_bloc.dart';

@immutable
abstract class ProjectEvent {}

class CreateProjectEvent extends ProjectEvent {
  final Project project;
  CreateProjectEvent(this.project);
}

class EditProjectEvent extends ProjectEvent {
  final Project project;
  EditProjectEvent(this.project);
}

class DeleteProjectEvent extends ProjectEvent {
  final Project project;
  DeleteProjectEvent(this.project);
}

class GetProjectsEvent extends ProjectEvent {}
