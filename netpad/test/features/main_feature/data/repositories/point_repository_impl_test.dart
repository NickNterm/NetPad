import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:netpad/core/failure/failure.dart';
import 'package:netpad/features/main_feature/data/local_data_source/main_local_data_source.dart';
import 'package:netpad/features/main_feature/data/models/point_data_model.dart';
import 'package:netpad/features/main_feature/data/models/project_model.dart';
import 'package:netpad/features/main_feature/data/repositories/point_repository_impl.dart';

class MockMainLocalDataSource extends Mock implements MainLocalDataSource {}

class MockProjectModel extends Fake implements ProjectModel {}

void main() {
  late MockMainLocalDataSource mockMainLocalDataSource;
  late PointRepositoryImpl pointRepositoryImpl;

  setUp(() {
    registerFallbackValue(MockProjectModel());
    mockMainLocalDataSource = MockMainLocalDataSource();
    pointRepositoryImpl = PointRepositoryImpl(
      localDataSource: mockMainLocalDataSource,
    );
  });

  group("Create Point", () {
    test("should return true when create point", () async {
      // arrange
      when(() => mockMainLocalDataSource.createPoint(PointDataModel.def()))
          .thenAnswer((_) async => PointDataModel.def());
      when(() => mockMainLocalDataSource.editProject(any()))
          .thenAnswer((_) async => ProjectModel.def());
      // act
      final result = await pointRepositoryImpl.createPoint(
        PointDataModel.def(),
        ProjectModel.def(),
      );
      // assert
      expect(result, Right(PointDataModel.def()));
      verify(() => mockMainLocalDataSource.createPoint(PointDataModel.def()));
      verify(() => mockMainLocalDataSource.editProject(any()));
      verifyNoMoreInteractions(mockMainLocalDataSource);
    });
    test('should return left with SQLiteFailure if error on local data',
        () async {
      //arrange
      when(() => mockMainLocalDataSource.createPoint(PointDataModel.def()))
          .thenThrow(Exception());
      //act
      final result = await pointRepositoryImpl.createPoint(
        PointDataModel.def(),
        ProjectModel.def(),
      );
      //assert
      expect(result, Left(SQLiteFailure()));
    });
  });

  group("Edit Point", () {
    test("should return true when edit point", () async {
      // arrange
      when(() => mockMainLocalDataSource.editPoint(PointDataModel.def()))
          .thenAnswer((_) async => PointDataModel.def());
      // act
      final result = await pointRepositoryImpl.editPoint(PointDataModel.def());
      // assert
      expect(result, Right(PointDataModel.def()));
      verify(() => mockMainLocalDataSource.editPoint(PointDataModel.def()));
      verifyNoMoreInteractions(mockMainLocalDataSource);
    });
    test("should return left with SQLiteFailure if error on local data",
        () async {
      // arrange
      when(() => mockMainLocalDataSource.editPoint(PointDataModel.def()))
          .thenThrow(Exception());
      // act
      final result = await pointRepositoryImpl.editPoint(PointDataModel.def());
      // assert
      expect(result, Left(SQLiteFailure()));
    });
  });

  group("Delete Point", () {
    test("should return true when delete point", () async {
      // arrange
      when(() => mockMainLocalDataSource.deletePoint(any()))
          .thenAnswer((_) async => 0);
      when(() => mockMainLocalDataSource.editProject(any()))
          .thenAnswer((_) async => ProjectModel.def());
      // act
      final result = await pointRepositoryImpl.deletePoint(
        0,
        ProjectModel.def(),
      );
      // assert
      expect(result, const Right(0));
      verify(() => mockMainLocalDataSource.deletePoint(any()));
      verify(() => mockMainLocalDataSource.editProject(any()));
      verifyNoMoreInteractions(mockMainLocalDataSource);
    });
    test("should return left with SQLiteFailure if error on local data",
        () async {
      // arrange
      when(() => mockMainLocalDataSource.deletePoint(any()))
          .thenThrow(Exception());
      // act
      final result = await pointRepositoryImpl.deletePoint(
        0,
        MockProjectModel(),
      );
      // assert
      expect(result, Left(SQLiteFailure()));
    });
  });

  group("Get Points", () {
    test("should return list of points", () async {
      List<PointDataModel> list = [PointDataModel.def()];
      // arrange
      when(() => mockMainLocalDataSource.getPoints())
          .thenAnswer((_) async => list);
      // act
      final result = await pointRepositoryImpl.getPoints();
      // assert
      expect(result, equals(Right(list)));
      verify(() => mockMainLocalDataSource.getPoints());
      verifyNoMoreInteractions(mockMainLocalDataSource);
    });
    test("should return left with SQLiteFailure if error on local data",
        () async {
      // arrange
      when(() => mockMainLocalDataSource.getPoints()).thenThrow(Exception());
      // act
      final result = await pointRepositoryImpl.getPoints();
      // assert
      expect(result, Left(SQLiteFailure()));
    });
  });
}
