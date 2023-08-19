import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:netpad/features/main_feature/domain/entities/project.dart';
import 'package:netpad/features/main_feature/domain/use_cases/create_project_use_case.dart';
import 'package:netpad/features/main_feature/domain/use_cases/delete_project_use_case.dart';
import 'package:netpad/features/main_feature/domain/use_cases/edit_project_use_case.dart';
import 'package:netpad/features/main_feature/domain/use_cases/get_projects_use_case.dart';
part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final CreateProjectUseCase createProjectUseCase;
  final EditProjectUseCase editProjectUseCase;
  final GetProjectsUseCase getProjectsUseCase;
  final DeleteProjectUseCase deleteProjectUseCase;
  ProjectBloc({
    required this.createProjectUseCase,
    required this.editProjectUseCase,
    required this.getProjectsUseCase,
    required this.deleteProjectUseCase,
  }) : super(ProjectLoaded(const [])) {
    on<ProjectEvent>((event, emit) async {
      if (event is CreateProjectEvent) {
        List<Project> projects = [];
        projects.addAll((state as ProjectLoaded).projects);
        final result = await createProjectUseCase(event.project);
        result.fold(
          (l) => emit(ProjectLoaded(projects)),
          (r) => emit(
            ProjectLoaded(projects..add(r)),
          ),
        );
      } else if (event is EditProjectEvent) {
        List<Project> projects = [];
        projects.addAll((state as ProjectLoaded).projects);
        final result = await editProjectUseCase(event.project);
        result.fold(
          (l) => emit(ProjectLoaded(projects)),
          (r) {
            projects.removeWhere((element) => element.id == event.project.id);
            projects.add(r);
            emit(
              ProjectLoaded(projects),
            );
          },
        );
      } else if (event is GetProjectsEvent) {
        List<Project> projects = [];
        projects.addAll((state as ProjectLoaded).projects);
        final result = await getProjectsUseCase();
        result.fold(
          (l) => emit(ProjectLoaded(projects)),
          (r) => emit(ProjectLoaded(r)),
        );
      } else if (event is DeleteProjectEvent) {
        List<Project> projects = [];
        projects.addAll((state as ProjectLoaded).projects);
        final result = await deleteProjectUseCase(event.project);
        result.fold(
          (l) => emit(ProjectLoaded(projects)),
          (r) {
            projects.removeWhere((element) => element.id == event.project.id);
            emit(ProjectLoaded(projects));
          },
        );
      }
    });
  }
}
