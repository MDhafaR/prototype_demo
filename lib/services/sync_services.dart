import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prototype_demo/services/service.dart';
import '../models/mata_air.dart';
import 'database_helper.dart';

class SyncService {
  Future<void> syncMataAir(List<MataAir> unsyncedData) async {
    try {
      // Jika tidak ada data yang perlu disinkronkan, langsung return
      if (unsyncedData.isEmpty) {
        print("No data to sync");
        return;
      }
      
      final url = Uri.parse('$BaseURL/mata-air/sync');
      print("Syncing to URL: $url");

      var request = http.MultipartRequest('POST', url);

      // Tambahkan data ke form-data
      for (var i = 0; i < unsyncedData.length; i++) {
        var mataAir = unsyncedData[i];
        request.fields['data[$i][local_id]'] = mataAir.localId;
        request.fields['data[$i][nama]'] = mataAir.nama;
        request.fields['data[$i][kota]'] = mataAir.kota;
        request.fields['data[$i][last_modified]'] = mataAir.lastModified;
      }

      print("Request headers: ${request.headers}");
      print("Request fields: ${request.fields}");

      var response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      print("Response status code: ${response.statusCode}");
      print("Response body: ${responseBody.body}");

      if (response.statusCode == 200) {
        final List<dynamic> syncedData = json.decode(responseBody.body);
        for (var data in syncedData) {
          final mataAir = MataAir.fromMap(data);
          await DatabaseHelper.instance.updateMataAir(mataAir);
          await DatabaseHelper.instance
              .updateMataAirSyncStatus(mataAir.localId, true);
        }
        print("Sync completed successfully");
      } else {
        throw Exception('Failed to sync data: ${response.statusCode}');
      }
    } catch (e) {
      print("Error during sync: $e");
      throw Exception('Error during sync: $e');
    }
  }
}