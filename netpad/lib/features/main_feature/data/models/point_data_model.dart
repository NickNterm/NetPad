import 'package:netpad/features/main_feature/domain/entities/point_data.dart';

class PointDataModel extends PointData {
  const PointDataModel({
    required super.id,
    required super.name,
    required super.antennaType,
    required super.antennaHeight,
    required super.startTime,
    required super.endTime,
    required super.notes,
    required super.images,
  });

  factory PointDataModel.empty() => const PointDataModel(
        id: 0,
        name: '',
        antennaType: '',
        antennaHeight: 0,
        startTime: '',
        endTime: '',
        notes: '',
        images: [],
      );

  factory PointDataModel.def() => const PointDataModel(
        id: 2,
        name: 'Name',
        antennaType: 'Type',
        antennaHeight: 100.0,
        startTime: '13:30',
        endTime: '14:30',
        notes: 'this is the notes',
        images: ['image1', 'image2'],
      );

  factory PointDataModel.fromEntity(PointData point) => PointDataModel(
        id: point.id,
        name: point.name,
        antennaType: point.antennaType,
        antennaHeight: point.antennaHeight,
        startTime: point.startTime,
        endTime: point.endTime,
        notes: point.notes,
        images: point.images,
      );

  String toJson() {
    String imageString = images.join(',');
    return '''
      {
        "id": $id,
        "name": "$name",
        "antennaType": "$antennaType",
        "antennaHeight": $antennaHeight,
        "startTime": "$startTime",
        "endTime": "$endTime",
        "notes": "$notes",
        "images": "$imageString"
      }
  ''';
  }

  PointDataModel copyWith({
    int? id,
    String? name,
    String? antennaType,
    double? antennaHeight,
    String? startTime,
    String? endTime,
    String? notes,
    List<String>? images,
  }) {
    return PointDataModel(
      id: id ?? this.id,
      name: name ?? this.name,
      antennaType: antennaType ?? this.antennaType,
      antennaHeight: antennaHeight ?? this.antennaHeight,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      notes: notes ?? this.notes,
      images: images ?? this.images,
    );
  }

  factory PointDataModel.fromJson(Map<String, dynamic> json) {
    List<String> images = [];
    if (json['images'] != '') {
      images = json['images'].split(',');
    }
    return PointDataModel(
      id: json['id'],
      name: json['name'],
      antennaType: json['antennaType'],
      antennaHeight: json['antennaHeight'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      notes: json['notes'],
      images: images,
    );
  }
}
