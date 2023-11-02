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
      body: Stack(
        children: [
          BlocBuilder<ProjectBloc, ProjectState>(
            builder: (context, state) {
              if (state is ProjectLoaded) {
                if (state.projects.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const Text(
                          'No projects',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
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
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Powered by ",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  "IQsoft",
                  style: TextStyle(
                    color: Colors.cyan.shade300,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
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
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
