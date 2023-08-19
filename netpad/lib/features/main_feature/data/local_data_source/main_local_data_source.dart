import 'dart:convert';

import 'package:netpad/constants/sql/tables.dart';
import 'package:netpad/features/main_feature/data/models/point_data_model.dart';
import 'package:netpad/features/main_feature/data/models/project_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class MainLocalDataSource {
  Future<PointDataModel> createPoint(PointDataModel point);
  Future<ProjectModel> createProject(ProjectModel project);
  Future<int> deletePoint(int id);
  Future<int> deleteProject(int id);
  Future<PointDataModel> editPoint(PointDataModel point);
  Future<ProjectModel> editProject(ProjectModel project);
  Future<bool> generateProjectPDF(int id);
  Future<List<PointDataModel>> getPoints();
  Future<List<ProjectModel>> getProjects();
}

class MainLocalDataSourceImpl extends MainLocalDataSource {
  final Database database;

  MainLocalDataSourceImpl({
    required this.database,
  });

  @override
  Future<PointDataModel> createPoint(PointDataModel point) async {
    Map<String, dynamic> values = jsonDecode(point.toJson());
    values.remove("id");
    int id = await database.insert(
      kPointsTable,
      values,
      nullColumnHack: "",
    );
    point = point.copyWith(id: id);
    return point;
  }

  @override
  Future<ProjectModel> createProject(ProjectModel project) async {
    Map<String, dynamic> values = jsonDecode(project.toJson());
    values.remove("id");
    int id = await database.insert(
      kProjectsTable,
      values,
      nullColumnHack: "",
    );
    project = project.copyWith(id: id);
    return project;
  }

  @override
  Future<int> deletePoint(int id) async {
    await database.delete(
      kPointsTable,
      where: "id = ?",
      whereArgs: [id],
    );
    return id;
  }

  @override
  Future<int> deleteProject(int id) async {
    await database.delete(
      kProjectsTable,
      where: "id = ?",
      whereArgs: [id],
    );
    return id;
  }

  @override
  Future<PointDataModel> editPoint(PointDataModel point) async {
    await database.update(
      kPointsTable,
      jsonDecode(point.toJson()),
      where: "id = ?",
      whereArgs: [point.id],
    );
    return point;
  }

  @override
  Future<ProjectModel> editProject(ProjectModel project) async {
    await database.update(
      kProjectsTable,
      jsonDecode(project.toJson()),
      where: "id = ?",
      whereArgs: [project.id],
    );
    return project;
  }

  @override
  Future<bool> generateProjectPDF(int id) {
    // TODO: implement generateProjectPDF
    throw UnimplementedError();
  }

  @override
  Future<List<PointDataModel>> getPoints() async {
    List<PointDataModel> points = [];
    List<Map<String, dynamic>> result = await database.query(
      kPointsTable,
    );
    for (var element in result) {
      print(element);
      points.add(PointDataModel.fromJson(element));
    }
    return points;
  }

  @override
  Future<List<ProjectModel>> getProjects() async {
    List<ProjectModel> projects = [];
    List<Map<String, dynamic>> result = await database.query(
      kProjectsTable,
    );
    for (var element in result) {
      projects.add(ProjectModel.fromJson(element));
    }
    return projects;
  }
}
