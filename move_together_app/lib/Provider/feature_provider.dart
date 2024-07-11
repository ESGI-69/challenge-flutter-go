import 'package:flutter/material.dart';
import 'package:move_together_app/core/services/feature_service.dart';
import 'package:move_together_app/core/models/app_settings.dart';

class FeatureProvider with ChangeNotifier {
  final FeatureService _featureService = FeatureService();
  List<AppSettings> _features = [];

  List<AppSettings> get features => _features;

  Future<void> loadFeatures() async {
    _features = await _featureService.fetchFeatures();
    notifyListeners();
  }

  bool isFeatureEnabled(String featureName) {
    return _features.any((feature) => feature.name == featureName && feature.isEnabled);
  }
}
