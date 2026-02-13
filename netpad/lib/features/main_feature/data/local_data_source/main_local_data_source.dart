import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:netpad/constants/sql/tables.dart';
import 'package:netpad/features/main_feature/data/models/point_data_model.dart';
import 'package:netpad/features/main_feature/data/models/project_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
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
  Future<bool> generateProjectPDF(int id) async {
    try {
      // Fetch the project by id
      final List<Map<String, dynamic>> projectResult = await database.query(
        kProjectsTable,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (projectResult.isEmpty) {
        return false;
      }

      final ProjectModel project = ProjectModel.fromJson(projectResult.first);

      // Fetch all points that belong to this project
      final List<PointDataModel> projectPoints = [];
      for (final pointId in project.points) {
        final List<Map<String, dynamic>> pointResult = await database.query(
          kPointsTable,
          where: 'id = ?',
          whereArgs: [pointId],
          limit: 1,
        );

        if (pointResult.isNotEmpty) {
          projectPoints.add(PointDataModel.fromJson(pointResult.first));
        }
      }

      if (projectPoints.isEmpty) {
        // Nothing to include in the PDF
        return false;
      }

      // Preload image bytes for each point
      final Map<int, List<Uint8List>> pointImages = {};
      for (final point in projectPoints) {
        final List<Uint8List> imagesBytes = [];
        for (final imagePath in point.images) {
          try {
            final file = File(imagePath);
            if (await file.exists()) {
              imagesBytes.add(await file.readAsBytes());
            }
          } catch (_) {
            // Ignore individual image failures
          }
        }
        pointImages[point.id] = imagesBytes;
      }

      final pdf = pw.Document();

      pw.TableRow buildRow(String label, String value) {
        return pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(
                label,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(value),
            ),
          ],
        );
      }

      // Create one page for each point with a small info table and images
      for (final point in projectPoints) {
        final List<Uint8List> imagesBytes = pointImages[point.id] ?? [];

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    project.name,
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Point: ${point.name}',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 12),
                  pw.Table(
                    border: pw.TableBorder.all(width: 0.5),
                    columnWidths: const {
                      0: pw.FlexColumnWidth(2),
                      1: pw.FlexColumnWidth(3),
                    },
                    children: [
                      buildRow('Antenna type', point.antennaType),
                      buildRow(
                        'Antenna height',
                        point.antennaHeight.toString(),
                      ),
                      buildRow('Start time', point.startTime),
                      buildRow('End time', point.endTime),
                      buildRow('Notes', point.notes),
                    ],
                  ),
                  if (imagesBytes.isNotEmpty) ...[
                    pw.SizedBox(height: 16),
                    pw.Text(
                      'Images',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final bytes in imagesBytes)
                          pw.Container(
                            width: 200,
                            height: 150,
                            child: pw.Image(
                              pw.MemoryImage(bytes),
                              fit: pw.BoxFit.cover,
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              );
            },
          ),
        );
      }

      // Save PDF to the app's documents directory
      final directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/project_${project.id}.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<PointDataModel>> getPoints() async {
    List<PointDataModel> points = [];
    List<Map<String, dynamic>> result = await database.query(
      kPointsTable,
    );
    for (var element in result) {
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
