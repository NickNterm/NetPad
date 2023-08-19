import 'dart:async';

import 'package:flutter/material.dart';
import 'package:netpad/features/main_feature/presentation/bloc/point_data/point_data_bloc.dart';
import 'package:netpad/features/main_feature/presentation/bloc/project/project_bloc.dart';
import 'package:netpad/injection/dependency_injection.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late StreamSubscription projectListener;
  late StreamSubscription pointListener;
  int loadedStuff = 0;
  @override
  void initState() {
    super.initState();
    pointListener = sl<PointDataBloc>().stream.listen((state) {
      if (state is PointDataLoaded) {
        print("point loaded");
        loadedStuff++;
        if (loadedStuff == 2) {
          Navigator.pushReplacementNamed(context, '/projects');
        }
      }
    });
    projectListener = sl<ProjectBloc>().stream.listen((state) {
      if (state is ProjectLoaded) {
        print("project loaded");
        loadedStuff++;
        if (loadedStuff == 2) {
          Navigator.pushReplacementNamed(context, '/projects');
        }
      }
    });
    sl<ProjectBloc>().add(GetProjectsEvent());
    sl<PointDataBloc>().add(GetPointsEvent());
  }

  @override
  void dispose() {
    projectListener.cancel();
    pointListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Loading"),
      ),
    );
  }
}
