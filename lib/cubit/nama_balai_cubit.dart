import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:high_q_paginated_drop_down/high_q_paginated_drop_down.dart';
import 'package:prototype_demo/models/nama_balai.dart';
import 'package:prototype_demo/services/local_nama_balai.dart';
import 'package:prototype_demo/services/nama_service.dart';

part 'nama_balai_state.dart';

class NamaBalaiCubit extends Cubit<NamaBalaiState> {
  final LocalNamaBalai _localNamaBalai;
  final int _pageSize = 10;
  int _currentPage = 1;

  NamaBalaiCubit(this._localNamaBalai) : super(NamaBalaiInitial());

  Future<void> loadNamaBalai({bool refresh = false}) async {
    try {
      if (state is NamaBalaiInitial || refresh) {
        emit(NamaBalaiLoading());
        _currentPage = 1;
      }

      final namaBalaiList = await _localNamaBalai.getNamaBalaiPaginated(
        (_currentPage - 1) * _pageSize,
        _pageSize,
      );
      final totalItems = await _localNamaBalai.getTotalNamaBalaiCount();

      final hasReachedMax = (_currentPage * _pageSize) >= totalItems;

      if (state is NamaBalaiLoaded && !refresh) {
        final currentState = state as NamaBalaiLoaded;
        emit(NamaBalaiLoaded(
          namaBalaiList: [...currentState.namaBalaiList, ...namaBalaiList],
          hasReachedMax: hasReachedMax,
          totalItems: totalItems,
        ));
      } else {
        emit(NamaBalaiLoaded(
          namaBalaiList: namaBalaiList,
          hasReachedMax: hasReachedMax,
          totalItems: totalItems,
        ));
      }
      _currentPage++;
    } catch (e) {
      emit(NamaBalaiError('Gagal memuat data Nama Balai: ${e.toString()}'));
    }
  }

  Future<void> loadMoreNamaBalai() async {
  if (state is NamaBalaiLoaded && !(state as NamaBalaiLoaded).hasReachedMax) {
    print("Loading more Nama Balai...");
    await loadNamaBalai();
  } else {
    print("Cannot load more: ${state is NamaBalaiLoaded ? 'Has reached max' : 'Not in loaded state'}");
  }
}


  // You might want to keep this method to sync with the API
  Future<void> fetchNamaBalaiFromApi() async {
    try {
      emit(NamaBalaiLoading());

      int skip = 0;
      final int take = 1000;
      bool hasMoreData = true;

      while (hasMoreData) {
        final namaBalaiList =
            await NamaService.getNamaBalaiPagination(skip, take);

        if (namaBalaiList.isEmpty) {
          hasMoreData = false;
        } else {
          List<int> existingId = await _localNamaBalai.getAllNamaBalaiId();

          for (var namaBalai in namaBalaiList) {
            if (!existingId.contains(namaBalai.id)) {
              await _localNamaBalai.insertNamaBalai(namaBalai);
              print("Berhasil menambahkan data ${namaBalai.nama} ke database");
            }
          }

          skip += take;
        }
      }

      _currentPage = 1;
      await loadNamaBalai(refresh: true);
      print("Berhasil mengambil data NamaBalai dari API");
    } catch (e) {
      emit(NamaBalaiError(
          'Gagal mengambil data NamaBalai dari API: ${e.toString()}'));
    }
  }

  Future<void> searchNamaBalai(String query) async {
    try {
      emit(NamaBalaiLoading());

      if (query.isEmpty) {
        await loadNamaBalai(refresh: true);
      } else {
        final filteredList = await _localNamaBalai.searchNamaBalai(query);
        final totalItems = filteredList.length;

        emit(NamaBalaiLoaded(
          namaBalaiList: filteredList,
          hasReachedMax:
              true, // Since we're loading all matching results at once
          totalItems: totalItems,
        ));
      }
    } catch (e) {
      emit(NamaBalaiError('Error searching Nama Balai: ${e.toString()}'));
    }
  }

  Future<List<MenuItemModel<NamaBalai>>?> getPaginatedNamaBalai(
    int page,
    String? searchText,
  ) async {
    try {
      final int pageSize = 10;
      final int skip = (page - 1) * pageSize;

      List<NamaBalai> namaBalaiList;
      if (searchText != null && searchText.isNotEmpty) {
        namaBalaiList = await _localNamaBalai.searchNamaBalai(searchText);
      } else {
        namaBalaiList = await _localNamaBalai.getNamaBalaiPaginated(skip, pageSize);
      }

      return namaBalaiList.map((namaBalai) {
        return MenuItemModel<NamaBalai>(
          value: namaBalai,
          label: namaBalai.nama,
          child: Text(
            namaBalai.nama,
            style: const TextStyle(color: Colors.black),
          ),
        );
      }).toList();
    } catch (e) {
      print('Error getting paginated Nama Balai: ${e.toString()}');
      return null;
    }
  }
}
