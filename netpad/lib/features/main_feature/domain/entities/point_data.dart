import 'package:equatable/equatable.dart';

class PointData extends Equatable {
  final int id;
  final String name;
  final String antennaType;
  final double antennaHeight;
  final String startTime;
  final String endTime;
  final String notes;
  final List<String> images;

  const PointData({
    required this.id,
    required this.name,
    required this.antennaType,
    required this.antennaHeight,
    required this.startTime,
    required this.endTime,
    required this.notes,
    required this.images,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        antennaType,
        antennaHeight,
        startTime,
        endTime,
        notes,
        images,
      ];
}
