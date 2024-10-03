import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prototype_demo/services/sync_services.dart';
import '../models/mata_air.dart';
import '../services/database_helper.dart';
import 'mata_air_state.dart';

class MataAirCubit extends Cubit<MataAirState> {
  MataAirCubit() : super(MataAirInitial());

  Future<void> loadMataAir() async {
    emit(MataAirLoading());
    try {
      final mataAirList = await DatabaseHelper.instance.getAllMataAir();
      emit(MataAirLoaded(mataAirList));
    } catch (e) {
      emit(MataAirError(e.toString()));
    }
  }

  Future<void> addMataAir(MataAir mataAir) async {
    try {
      await DatabaseHelper.instance.insertMataAir(mataAir);
      await loadMataAir();
    } catch (e) {
      emit(MataAirError(e.toString()));
    }
  }

  Future<void> updateMataAir(MataAir mataAir) async {
    try {
      await DatabaseHelper.instance.updateMataAir(mataAir);
      await loadMataAir();
    } catch (e) {
      emit(MataAirError(e.toString()));
    }
  }

  Future<void> deleteMataAir(String localId) async {
    try {
      await DatabaseHelper.instance.deleteMataAir(localId);
      await loadMataAir();
    } catch (e) {
      emit(MataAirError(e.toString()));
    }
  }

  Future<void> syncMataAir() async {
    emit(MataAirSyncing());
    try {
      final unsyncedData = await DatabaseHelper.instance.getUnsyncedMataAir();
      await SyncService().syncMataAir(unsyncedData);
      await loadMataAir();
    } catch (e) {
      emit(MataAirError('Sync failed: ${e.toString()}'));
    }
  }
}
