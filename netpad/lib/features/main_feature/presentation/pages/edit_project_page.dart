import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netpad/features/main_feature/data/models/project_model.dart';
import 'package:netpad/features/main_feature/domain/entities/point_data.dart';
import 'package:netpad/features/main_feature/domain/entities/project.dart';
import 'package:netpad/features/main_feature/presentation/bloc/point_data/point_data_bloc.dart';
import 'package:netpad/features/main_feature/presentation/bloc/project/project_bloc.dart';
import 'package:netpad/features/main_feature/presentation/components/divider/custom_divider.dart';
import 'package:netpad/features/main_feature/presentation/pages/point_page.dart';
import 'package:netpad/injection/dependency_injection.dart';

class EditProjectPage extends StatefulWidget {
  const EditProjectPage({
    super.key,
    required this.project,
  });

  final Project project;

  @override
  State<EditProjectPage> createState() => _EditProjectPageState();
}

class _EditProjectPageState extends State<EditProjectPage> {
  late Project project;
  late StreamSubscription projectListener;
  @override
  void initState() {
    super.initState();
    project = widget.project;
    projectListener = sl<ProjectBloc>().stream.listen((state) {
      if (state is ProjectLoaded) {
        if (mounted) {
          setState(() {
            try {
              project = state.projects.firstWhere(
                (element) => element.id == project.id,
              );
            } catch (_) {}
          });
        }
      }
    });
  }

  @override
  void dispose() {
    projectListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 35,
          icon: const Icon(
            Icons.keyboard_arrow_left_rounded,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            iconSize: 27,
            icon: const Icon(
              Icons.delete_rounded,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Delete Project"),
                    content: const Text(
                      "Are you sure you want to delete this project?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("No"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          sl<ProjectBloc>().add(
                            DeleteProjectEvent(widget.project),
                          );
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
        title: const Text("Edit Project"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                    blurRadius: 5,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Text(
                    "Project Name: ",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    project.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.edit_rounded,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          TextEditingController controller =
                              TextEditingController(
                            text: widget.project.name,
                          );
                          return AlertDialog(
                            title: const Text("Edit Project Name"),
                            content: TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                hintText: "Project Name",
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  sl<ProjectBloc>().add(
                                    EditProjectEvent(
                                      ProjectModel.fromEntity(project).copyWith(
                                        name: controller.text,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text("Save"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Points In Project",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            const CustomDivider(),
            const SizedBox(height: 10),
            BlocBuilder<PointDataBloc, PointDataState>(
                builder: (context, state) {
              if (state is PointDataLoaded) {
                List<PointData> pointDataList = [];
                print(state.pointDataList);
                for (var element in project.points) {
                  print(element);
                  if (state.pointDataList
                      .any((pointData) => pointData.id == element)) {
                    pointDataList.add(
                      state.pointDataList.firstWhere(
                        (pointData) => pointData.id == element,
                      ),
                    );
                  }
                }
                return ListView.builder(
                  itemBuilder: (context, index) => Container(
                    height: 80,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          offset: const Offset(0, 3),
                          blurRadius: 5,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name: ${pointDataList[index].name}",
                              ),
                              Text(
                                "Type: ${pointDataList[index].antennaType}",
                              ),
                              Text(
                                "Antenna Height: ${pointDataList[index].antennaHeight} m",
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: pointDataList[index].images.length == 1,
                          child: Positioned(
                            right: 0,
                            child: Image.memory(
                              base64Decode(
                                pointDataList[index].images.first,
                              ),
                              height: 80,
                              width: 80,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  itemCount: pointDataList.length,
                  shrinkWrap: true,
                );
              } else {
                return const CircularProgressIndicator();
              }
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PointPage(
                project: widget.project,
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add_rounded,
        ),
      ),
    );
  }
}
