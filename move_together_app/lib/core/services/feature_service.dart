import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:move_together_app/core/models/app_settings.dart';

class FeatureService {
  final String apiUrl = '/app-settings';

  Future<List<AppSettings>> fetchFeatures() async {
    print('fetchFeatures');
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      print('jsonResponse');
      print(jsonResponse);
      return jsonResponse.map((feature) => AppSettings.fromJson(feature)).toList();
    } else {
      throw Exception('Failed to load features');
    }
  }
}