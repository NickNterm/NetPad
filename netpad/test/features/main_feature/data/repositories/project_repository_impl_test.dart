import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:netpad/core/failure/failure.dart';
import 'package:netpad/features/main_feature/data/local_data_source/main_local_data_source.dart';
import 'package:netpad/features/main_feature/data/models/project_model.dart';
import 'package:netpad/features/main_feature/data/repositories/project_repository_impl.dart';

class MockMainLocalDataSource extends Mock implements MainLocalDataSource {}

void main() {
  late MockMainLocalDataSource mockMainLocalDataSource;
  late ProjectRepositoryImpl projectRepositoryImpl;

  setUp(() {
    mockMainLocalDataSource = MockMainLocalDataSource();
    projectRepositoryImpl = ProjectRepositoryImpl(
      localDataSource: mockMainLocalDataSource,
    );
  });

  group("Create Project", () {
    test('should return true while create project succesfully', () async {
      // arrange
      when(() => mockMainLocalDataSource.createProject(ProjectModel.def()))
          .thenAnswer((_) async => ProjectModel.def());
      // act
      final result =
          await projectRepositoryImpl.createProject(ProjectModel.def());
      // assert
      expect(result, Right(ProjectModel.def()));
      verify(() => mockMainLocalDataSource.createProject(ProjectModel.def()));
      verifyNoMoreInteractions(mockMainLocalDataSource);
    });
    test('Should return left and SQLiteFailure in error', () async {
      // arrange
      when(() => mockMainLocalDataSource.createProject(ProjectModel.def()))
          .thenThrow(Exception());
      // act
      final result =
          await projectRepositoryImpl.createProject(ProjectModel.def());
      // assert
      expect(result, Left(SQLiteFailure()));
    });
  });

  group("Edit Project", () {
    test("should return true while edit project succesfully", () async {
      // arrange
      when(() => mockMainLocalDataSource.editProject(ProjectModel.def()))
          .thenAnswer((_) async => ProjectModel.def());
      // act
      final result =
          await projectRepositoryImpl.editProject(ProjectModel.def());
      // assert
      expect(result, Right(ProjectModel.def()));
      verify(() => mockMainLocalDataSource.editProject(ProjectModel.def()));
      verifyNoMoreInteractions(mockMainLocalDataSource);
    });

    test("should return left and SQLiteFailure in error", () async {
      // arrange
      when(() => mockMainLocalDataSource.editProject(ProjectModel.def()))
          .thenThrow(Exception());
      // act
      final result =
          await projectRepositoryImpl.editProject(ProjectModel.def());
      // assert
      expect(result, Left(SQLiteFailure()));
    });
  });

  group("Delete Project", () {
    test("should return true while delete project succesfully", () async {
      // arrange
      when(() => mockMainLocalDataSource.deleteProject(any()))
          .thenAnswer((_) async => 1);
      when(() => mockMainLocalDataSource.deletePoint(any()))
          .thenAnswer((_) async => 1);
      // act
      final result =
          await projectRepositoryImpl.deleteProject(ProjectModel.def());
      // assert
      expect(result, const Right(1));
      verify(() => mockMainLocalDataSource.deleteProject(1));
      verify(() => mockMainLocalDataSource.deletePoint(1));
      verify(() => mockMainLocalDataSource.deletePoint(2));
      verify(() => mockMainLocalDataSource.deletePoint(3));
      verifyNoMoreInteractions(mockMainLocalDataSource);
    });

    test("should return left and SQLiteFailure in error", () async {
      // arrange
      when(() => mockMainLocalDataSource.deleteProject(any()))
          .thenThrow(Exception());
      // act
      final result = await projectRepositoryImpl.deleteProject(
        ProjectModel.def(),
      );
      // assert
      expect(result, Left(SQLiteFailure()));
    });

    test("should delete all points in project", () async {
      // arrange
      when(() => mockMainLocalDataSource.deleteProject(any()))
          .thenAnswer((_) async => 1);
      when(() => mockMainLocalDataSource.deletePoint(any()))
          .thenAnswer((_) async => 1);
      // act
      await projectRepositoryImpl.deleteProject(ProjectModel.def());
      // assert
      verify(() => mockMainLocalDataSource.deleteProject(1));
      verify(() => mockMainLocalDataSource.deletePoint(1));
      verify(() => mockMainLocalDataSource.deletePoint(2));
      verify(() => mockMainLocalDataSource.deletePoint(3));
      verifyNoMoreInteractions(mockMainLocalDataSource);
    });
  });

  group("Get Project", () {
    test("should return project model", () async {
      List<ProjectModel> list = [ProjectModel.def()];
      // arrange
      when(() => mockMainLocalDataSource.getProjects())
          .thenAnswer((_) async => list);
      // act
      final result = await projectRepositoryImpl.getProjects();
      // assert
      expect(result, Right(list));
      verify(() => mockMainLocalDataSource.getProjects());
      verifyNoMoreInteractions(mockMainLocalDataSource);
    });
    test("should return left and SQLiteFailure in error", () async {
      // arrange
      when(() => mockMainLocalDataSource.getProjects()).thenThrow(Exception());
      // act
      final result = await projectRepositoryImpl.getProjects();
      // assert
      expect(result, Left(SQLiteFailure()));
    });
  });

  group("Generate PDF", () {
    test("should return true if success", () async {
      // arrange
      when(() => mockMainLocalDataSource.generateProjectPDF(any()))
          .thenAnswer((_) async => true);
      // act
      final result = await projectRepositoryImpl.generateProjectPDF(0);
      // assert
      expect(result, const Right(true));
      verify(() => mockMainLocalDataSource.generateProjectPDF(0));
      verifyNoMoreInteractions(mockMainLocalDataSource);
    });
    test("should return left and SQLiteFailure in error", () async {
      // arrange
      when(() => mockMainLocalDataSource.generateProjectPDF(any()))
          .thenThrow(Exception());
      // act
      final result = await projectRepositoryImpl.generateProjectPDF(0);
      // assert
      expect(result, Left(SQLiteFailure()));
    });
  });
}
