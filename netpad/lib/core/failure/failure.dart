import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List<Object?> props = const <Object>[]]) : super();
}

class SQLiteFailure extends Failure {
  @override
  List<Object?> get props => [];
}
