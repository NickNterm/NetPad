import 'package:get_it/get_it.dart';
import 'package:netpad/constants/sql/tables.dart';
import 'package:netpad/features/main_feature/data/local_data_source/main_local_data_source.dart';
import 'package:netpad/features/main_feature/data/repositories/point_repository_impl.dart';
import 'package:netpad/features/main_feature/data/repositories/project_repository_impl.dart';
import 'package:netpad/features/main_feature/domain/repositories/point_repository.dart';
import 'package:netpad/features/main_feature/domain/repositories/project_repository.dart';
import 'package:netpad/features/main_feature/domain/use_cases/create_point_use_case.dart';
import 'package:netpad/features/main_feature/domain/use_cases/create_project_use_case.dart';
import 'package:netpad/features/main_feature/domain/use_cases/delete_point_use_case.dart';
import 'package:netpad/features/main_feature/domain/use_cases/delete_project_use_case.dart';
import 'package:netpad/features/main_feature/domain/use_cases/edit_point_use_case.dart';
import 'package:netpad/features/main_feature/domain/use_cases/edit_project_use_case.dart';
import 'package:netpad/features/main_feature/domain/use_cases/generate_project_pdf_use_case.dart';
import 'package:netpad/features/main_feature/domain/use_cases/get_points_use_case.dart';
import 'package:netpad/features/main_feature/domain/use_cases/get_projects_use_case.dart';
import 'package:netpad/features/main_feature/presentation/bloc/point_data/point_data_bloc.dart';
import 'package:netpad/features/main_feature/presentation/bloc/project/project_bloc.dart';
import 'package:sqflite/sqflite.dart';

GetIt sl = GetIt.instance;
Future<void> initDependencies() async {
  //Bloc
  sl.registerLazySingleton<ProjectBloc>(
    () => ProjectBloc(
      createProjectUseCase: sl(),
      deleteProjectUseCase: sl(),
      editProjectUseCase: sl(),
      getProjectsUseCase: sl(),
    ),
  );

  sl.registerLazySingleton<PointDataBloc>(
    () => PointDataBloc(
      createPointUseCase: sl(),
      deletePointUseCase: sl(),
      editPointUseCase: sl(),
      getPointsUseCase: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<PointRepository>(
    () => PointRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<MainLocalDataSource>(
    () => MainLocalDataSourceImpl(
      database: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(
    () => CreateProjectUseCase(sl()),
  );
  sl.registerLazySingleton(
    () => CreatePointUseCase(sl()),
  );
  sl.registerLazySingleton(
    () => EditPointUseCase(sl()),
  );
  sl.registerLazySingleton(
    () => EditProjectUseCase(sl()),
  );
  sl.registerLazySingleton(
    () => DeleteProjectUseCase(sl()),
  );
  sl.registerLazySingleton(
    () => DeletePointUseCase(sl()),
  );
  sl.registerLazySingleton(
    () => GetPointsUseCase(sl()),
  );
  sl.registerLazySingleton(
    () => GetProjectsUseCase(sl()),
  );
  sl.registerLazySingleton(
    () => GenerateProjectPDFUseCase(sl()),
  );

  // Core
  var databasesPath = await getDatabasesPath();
  String path = '${databasesPath}demo.db';
  Database database = await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    await db.execute(
      'CREATE TABLE $kPointsTable (id INTEGER PRIMARY KEY, name TEXT, antennaType TEXT, antennaHeight DOUBLE, startTime TEXT, endTime TEXT, notes TEXT, images TEXT)',
    );
    await db.execute(
      'CREATE TABLE $kProjectsTable (id INTEGER PRIMARY KEY, name TEXT, points TEXT)',
    );
  });
  sl.registerLazySingleton<Database>(() => database);
}
