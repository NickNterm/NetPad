import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netpad/features/loading_feature/presentation/pages/loading_page.dart';
import 'package:netpad/features/main_feature/presentation/bloc/point_data/point_data_bloc.dart';
import 'package:netpad/features/main_feature/presentation/bloc/project/project_bloc.dart';
import 'package:netpad/features/main_feature/presentation/pages/project_page.dart';
import 'package:netpad/injection/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<PointDataBloc>()),
        BlocProvider(create: (_) => sl<ProjectBloc>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
          primarySwatch: Colors.cyan,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
            foregroundColor: Colors.white,
            backgroundColor: Colors.cyan,
          ),
          dialogTheme: const DialogTheme(
            elevation: 0,
          ),
          useMaterial3: true,
        ),
        home: const LoadingPage(),
        routes: {
          '/loading': (_) => const LoadingPage(),
          '/projects': (_) => const ProjectsPage(),
        },
      ),
    );
  }
}
