import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final int id;
  final String name;
  final List<int> points;

  const Project({
    required this.id,
    required this.name,
    required this.points,
  });

  @override
  List<Object?> get props => [id, name, points];
}
