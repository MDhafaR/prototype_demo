import 'package:equatable/equatable.dart';
import '../models/mata_air.dart';

abstract class MataAirState extends Equatable {
  const MataAirState();

  @override
  List<Object> get props => [];
}

class MataAirInitial extends MataAirState {}

class MataAirLoading extends MataAirState {}

class MataAirLoaded extends MataAirState {
  final List<MataAir> mataAirList;

  const MataAirLoaded(this.mataAirList);

  @override
  List<Object> get props => [mataAirList];
}

class MataAirError extends MataAirState {
  final String message;

  const MataAirError(this.message);

  @override
  List<Object> get props => [message];
}

class MataAirSyncing extends MataAirState {}