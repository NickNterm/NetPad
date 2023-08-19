import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netpad/features/main_feature/domain/entities/project.dart';
import 'package:netpad/features/main_feature/presentation/bloc/project/project_bloc.dart';
import 'package:netpad/features/main_feature/presentation/components/dialogs/create_project_dialog.dart';
import 'package:netpad/features/main_feature/presentation/components/list_item/project_list_item.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NetPad'),
      ),
      body: BlocBuilder<ProjectBloc, ProjectState>(
        builder: (context, state) {
          if (state is ProjectLoaded) {
            if (state.projects.isEmpty) {
              return const Center(
                child: Text('No projects'),
              );
            }
            return ListView.builder(
              itemCount: state.projects.length,
              itemBuilder: (context, index) {
                Project project = state.projects[index];
                return ProjectListItem(project: project);
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return const CreateProjectDialog();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
