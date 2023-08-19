import 'package:netpad/features/main_feature/domain/entities/project.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.points,
  });

  factory ProjectModel.empty() => const ProjectModel(
        id: 0,
        name: '',
        points: [],
      );

  factory ProjectModel.def() => const ProjectModel(
        id: 1,
        name: 'Name',
        points: [1, 2, 3],
      );

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    List<int> points = [];
    for (String point in json['points'].split(',')) {
      if (point.isNotEmpty) {
        points.add(int.parse(point));
      }
    }
    return ProjectModel(
      id: json['id'],
      name: json['name'],
      points: points,
    );
  }

  factory ProjectModel.fromEntity(Project project) {
    return ProjectModel(
      id: project.id,
      name: project.name,
      points: project.points,
    );
  }

  ProjectModel copyWith({
    int? id,
    String? name,
    List<int>? points,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      points: points ?? this.points,
    );
  }

  String toJson() {
    String pointsString = points.join(',');
    return '''
      {
        "id": $id,
        "name": "$name",
        "points": "$pointsString"
      }
  ''';
  }
}
