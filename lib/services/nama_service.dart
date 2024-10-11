import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prototype_demo/models/nama_balai.dart';

class NamaService {
  static Future<List<NamaBalai>> getNamaBalaiPagination(
      int skip, int take) async {
    final baseUrl = 'http://103.149.208.33/api/data/daerahAliranSungai';

    final queryParams = {
      'data': jsonEncode({
        "skip": skip,
        "take": take,
        "select": ["master_das.id", "master_das.nama"]
      })
    };

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

    try {
      var response = await http.get(
        uri,
        headers: {
          'Authorization':
              'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI5MzQzMDgzNi1hZTQwLTRjY2MtYTNmMC1hNzU0ZDFjMGI1NzciLCJqdGkiOiJlYjI4ZDgyOGVhYTUyNDUzNjBkZGIzYjc2NzM3YWRjZjczNmRhNmQ4MGNmODU1ODAwYTYwOWViYmNhNTRmNzA0MWQ2MGIxM2I3MTJmN2M4MSIsImlhdCI6MTcyODM2ODk4Ni4xNzI0ODMsIm5iZiI6MTcyODM2ODk4Ni4xNzI0ODUsImV4cCI6MTczMDk2MDk4Ni4xNjQ3ODQsInN1YiI6IjE1NSIsInNjb3BlcyI6W119.ALYg5d6o4nAkrnnUNH23UqSKhp0Nauu6JkUjZ10au6EO5Qn5So41ohxH_jKviA_a8q73mTn5BSVkON8mHu3SnNCJ4ICtWtrHpJ9G_KNmnyWWpg83smHpmMENuiSZ1AMYfWP71ecSl4QScnnOP40zy993u6-xn5MfpATnLzU2WSTpQFsANa6D1o56DdIM1zHpSe3hMnCEe8fUz2_-EKbZ3I-dz1X35ok4OJrbhwNW7-3LoKcz5sWjmHIp4kIVCTGp2fKuKw0039NXpeRDBZghnHTVlyoLviqLp2rzGns91kkUg2_ijvNtf7YrFV6FHyvkxzoy3Qsvm9i0lZVAq4x5QfGjTJ-_o15Z_g3nWayZSDNMS9CV0eXGEGNenpGtCR1G6oWhdhYqSeWw7v2zpxnLwT_V-zAB9YGPRt99_Md2rSVyVjv1twGpmg9o2uSHRDTLN-s4jtd_KmmN1p72JxzlMhQkLQCpq5Yg-n0vcMb7E1_j4W0q9eNSBkcfd0wzZyYPsUMmfbTfMhMhLeos1rbIvsuHe9e8Yx8rKIRnHvmwRflN4MGMiqriC-jQDXWP37yImguzJ4mWqkKWmobkruNtommc-jbpUAgK5BSTp0FT2exNkCQOQcWS-AunxDjhrwMbxiDOxXsXdHmj3JbJOKPmh_XTJ6uvVQ8KqnbHgJ5WyMw',
          'Accept': 'application/json',
        },
      );

      print("Response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true &&
            data['data'] != null &&
            data['data']['data'] != null) {
          List<dynamic> namaBalaiData = data['data']['data'];
          return namaBalaiData
              .map<NamaBalai>((json) => NamaBalai.fromJson(json))
              .toList();
        } else {
          print("Unexpected data structure in response");
          return [];
        }
      } else {
        print("Failed to get nama balai. Status code: ${response.statusCode}");
        try {
          Map<String, dynamic> errorData = jsonDecode(response.body);
          String errorMessage = errorData['message'] ?? 'Unknown error';
          print('Error message: $errorMessage');
        } catch (e) {
          print('Could not parse error message: $e');
        }
        return [];
      }
    } catch (e) {
      print("Error getting nama balai: $e");
      return [];
    }
  }
}
