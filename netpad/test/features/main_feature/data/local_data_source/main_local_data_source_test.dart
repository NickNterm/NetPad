import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:netpad/features/main_feature/data/local_data_source/main_local_data_source.dart';
import 'package:netpad/features/main_feature/data/models/point_data_model.dart';
import 'package:netpad/features/main_feature/data/models/project_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  late MainLocalDataSource mainLocalDataSourceImpl;
  late Database database;

  setUp(() async {
    sqfliteFfiInit();

    database = MockDatabase();

    mainLocalDataSourceImpl = MainLocalDataSourceImpl(database: database);
  });

  group("Creation", () {
    group("Points", () {
      test("Should create a new point", () async {
        //arrange
        when(
          () => database.insert(
            any(),
            any(),
            nullColumnHack: '',
          ),
        ).thenAnswer((_) async => 10);
        //act
        final point =
            await mainLocalDataSourceImpl.createPoint(PointDataModel.def());
        //assert
        expect(point, PointDataModel.def().copyWith(id: 10));
      });
      test("should throw Exception if error on database", () {
        //arrange
        when(() => database.insert(any(), any(), nullColumnHack: ''))
            .thenThrow(Exception());
        //act
        final call = mainLocalDataSourceImpl.createPoint;
        //assert
        expect(() => call(PointDataModel.def()), throwsException);
      });
    });
    group("Projects", () {
      test("Should create a new project", () async {
        //arrange
        when(
          () => database.insert(
            any(),
            any(),
            nullColumnHack: '',
          ),
        ).thenAnswer((_) async => 10);
        //act
        final project =
            await mainLocalDataSourceImpl.createProject(ProjectModel.def());
        //assert
        expect(project, ProjectModel.def().copyWith(id: 10));
        verify(
          () => database.insert(
            any(),
            any(),
            nullColumnHack: '',
          ),
        );
        verifyNoMoreInteractions(database);
      });
      test("should throw Exception if error on database", () {
        //arrange
        when(() => database.insert(any(), any(), nullColumnHack: ''))
            .thenThrow(Exception());
        //act
        final call = mainLocalDataSourceImpl.createProject;
        //assert
        expect(() => call(ProjectModel.def()), throwsException);
      });
    });
  });

  group('Edit', () {
    group('Point', () {
      test('Should create a point and return it if success', () async {
        //arrange
        when(() => database.update(
              any(),
              any(),
              where: any(named: "where"),
              whereArgs: any(named: "whereArgs"),
            )).thenAnswer((_) async => PointDataModel.def().id);
        //act
        final point =
            await mainLocalDataSourceImpl.editPoint(PointDataModel.def());
        //assert
        expect(point, PointDataModel.def());
        verify(
          () => database.update(
            any(),
            any(),
            where: any(named: "where"),
            whereArgs: any(named: "whereArgs"),
          ),
        );
        verifyNoMoreInteractions(database);
      });
      test('Should return Throw when a problem is on db', () async {
        //arrange
        when(() => database.update(
              any(),
              any(),
              where: any(named: "where"),
              whereArgs: any(named: "whereArgs"),
            )).thenThrow(Exception());
        //act
        final call = mainLocalDataSourceImpl.editPoint;
        //assert
        expect(() => call(PointDataModel.def()), throwsException);
      });
    });
    group('Project', () {
      test('Should create a project and return it if success', () async {
        //arrange
        when(() => database.update(
              any(),
              any(),
              where: any(named: "where"),
              whereArgs: any(named: "whereArgs"),
            )).thenAnswer((_) async => 1);
        //act
        final project =
            await mainLocalDataSourceImpl.editProject(ProjectModel.def());
        //assert
        expect(project, ProjectModel.def());
        verify(
          () => database.update(
            any(),
            any(),
            where: any(named: "where"),
            whereArgs: any(named: "whereArgs"),
          ),
        );
        verifyNoMoreInteractions(database);
      });
      test('Should return Throw when a problem is on db', () async {
        //arrange
        when(() => database.update(
              any(),
              any(),
              where: any(named: "where"),
              whereArgs: any(named: "whereArgs"),
            )).thenThrow(Exception());
        //act
        final call = mainLocalDataSourceImpl.editProject;
        //assert
        expect(() => call(ProjectModel.def()), throwsException);
      });
    });
  });

  group("Delete", () {
    group('Points', () {
      test("Should delete a point", () async {
        //arrange
        when(() => database.delete(
              any(),
              where: any(named: "where"),
              whereArgs: any(named: "whereArgs"),
            )).thenAnswer((_) async => 1);
        //act
        final point = await mainLocalDataSourceImpl.deletePoint(1);
        //assert
        expect(point, 1);
        verify(
          () => database.delete(
            any(),
            where: any(named: "where"),
            whereArgs: any(named: "whereArgs"),
          ),
        );
        verifyNoMoreInteractions(database);
      });
      test("Should throw error in case db throws error", () {
        //arrange
        when(() => database.delete(
              any(),
              where: any(named: "where"),
              whereArgs: any(named: "whereArgs"),
            )).thenThrow(Exception());
        //act
        final call = mainLocalDataSourceImpl.deletePoint;
        //assert
        expect(() => call(1), throwsException);
      });
    });
    group("Project", () {
      test("Should delete a project", () async {
        //arrange
        when(() => database.delete(
              any(),
              where: any(named: "where"),
              whereArgs: any(named: "whereArgs"),
            )).thenAnswer((_) async => 1);
        //act
        final project = await mainLocalDataSourceImpl.deleteProject(1);
        //assert
        expect(project, 1);
        verify(
          () => database.delete(
            any(),
            where: any(named: "where"),
            whereArgs: any(named: "whereArgs"),
          ),
        );
        verifyNoMoreInteractions(database);
      });
      test("Should throw error in case db throws error", () {
        //arrange
        when(() => database.delete(
              any(),
              where: any(named: "where"),
              whereArgs: any(named: "whereArgs"),
            )).thenThrow(Exception());
        //act
        final call = mainLocalDataSourceImpl.deleteProject;
        //assert
        expect(() => call(0), throwsException);
      });
    });
  });

  group("Get Data", () {
    group("Points", () {
      test("should return points", () async {
        //arrange
        when(() => database.query(
              any(),
              where: any(named: "where"),
              whereArgs: any(named: "whereArgs"),
            )).thenAnswer(
          (_) async => [
            jsonDecode(
              PointDataModel.def().toJson(),
            )
          ],
        );
        //act
        final points = await mainLocalDataSourceImpl.getPoints();
        //assert
        expect(points, [PointDataModel.def()]);
        verify(
          () => database.query(
            any(),
            where: any(named: "where"),
            whereArgs: any(named: "whereArgs"),
          ),
        );
        verifyNoMoreInteractions(database);
      });
    });
    group("Project", () {
      test("should return Projects", () async {
        //arrange
        when(() => database.query(
              any(),
              where: any(named: "where"),
              whereArgs: any(named: "whereArgs"),
            )).thenAnswer(
          (_) async => [
            jsonDecode(
              ProjectModel.def().toJson(),
            )
          ],
        );
        //act
        final points = await mainLocalDataSourceImpl.getProjects();
        //assert
        expect(points, [ProjectModel.def()]);
        verify(
          () => database.query(
            any(),
            where: any(named: "where"),
            whereArgs: any(named: "whereArgs"),
          ),
        );
        verifyNoMoreInteractions(database);
      });
      test("should return empty list", () async {
        //arrange
        when(() => database.query(
              any(),
              where: any(named: "where"),
              whereArgs: any(named: "whereArgs"),
            )).thenAnswer(
          (_) async => [],
        );
        //act
        final points = await mainLocalDataSourceImpl.getProjects();
        //assert
        expect(points, []);
        verify(
          () => database.query(
            any(),
            where: any(named: "where"),
            whereArgs: any(named: "whereArgs"),
          ),
        );
        verifyNoMoreInteractions(database);
      });
    });
  });
}
