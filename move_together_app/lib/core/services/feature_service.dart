import 'package:move_together_app/core/models/app_settings.dart';
import 'package:move_together_app/core/services/api.dart';


class FeatureService {
  final api = Api().dio;
  final String apiUrl = '/app-settings';

  Future<List<AppSettings>> fetchFeatures() async {
    final response = await api.get('/app-settings');
    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return (response.data as List).map((feature) => AppSettings.fromJson(feature)).toList();
    } else {
      throw Exception('Failed to load features');
    }
  }
}
