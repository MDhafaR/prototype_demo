part of 'nama_balai_cubit.dart';

abstract class NamaBalaiState extends Equatable {
  const NamaBalaiState();

  @override
  List<Object> get props => [];
}

class NamaBalaiInitial extends NamaBalaiState {}

class NamaBalaiLoading extends NamaBalaiState {}

class NamaBalaiLoaded extends NamaBalaiState {
  final List<NamaBalai> namaBalaiList;
  final bool hasReachedMax;
  final int totalItems;

  const NamaBalaiLoaded({
    required this.namaBalaiList,
    required this.hasReachedMax,
    required this.totalItems,
  });

  @override
  List<Object> get props => [namaBalaiList, hasReachedMax, totalItems];
}

class NamaBalaiError extends NamaBalaiState {
  final String message;

  const NamaBalaiError(this.message);

  @override
  List<Object> get props => [message];
}
