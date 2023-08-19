import 'package:flutter/material.dart';
import 'package:netpad/features/main_feature/domain/entities/project.dart';
import 'package:netpad/features/main_feature/presentation/bloc/project/project_bloc.dart';
import 'package:netpad/injection/dependency_injection.dart';

class CreateProjectDialog extends StatefulWidget {
  const CreateProjectDialog({
    super.key,
  });

  @override
  State<CreateProjectDialog> createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends State<CreateProjectDialog> {
  TextEditingController controller = TextEditingController();
  String errorText = '';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Project'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Project name',
                border: InputBorder.none,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
            child: Text(
              errorText,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (controller.text.isNotEmpty) {
              sl<ProjectBloc>().add(
                CreateProjectEvent(
                  Project(
                    id: 0,
                    name: controller.text,
                    points: const [],
                  ),
                ),
              );
              Navigator.pop(context);
            } else {
              setState(() {
                errorText = 'Project name cannot be empty';
              });
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
