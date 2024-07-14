import 'package:move_together_app/core/models/feature.dart';
import 'package:move_together_app/core/services/api.dart';


class FeatureService {
  final api = Api().dio;

  Future<List<Feature>> getAll() async {
    final response = await api.get('/app-settings');
    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return (response.data as List).map((feature) => Feature.fromJson(feature)).toList();
    } else {
      throw Exception('Failed to load features');
    }
  }
}