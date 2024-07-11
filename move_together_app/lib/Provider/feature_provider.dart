import 'package:flutter/material.dart';
import 'package:move_together_app/core/services/feature_service.dart';
import 'package:move_together_app/core/models/feature.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:provider/provider.dart';

class FeatureProvider with ChangeNotifier {
  final FeatureService _featureService = FeatureService();
  List<Feature> _features = [];

  List<Feature> get features => _features;

  Future<void> loadFeatures() async {
    _features = await _featureService.getAll();
    notifyListeners();
  }

  bool isFeatureEnabled(FeatureNames featureName) {
    return _features.any((feature) => feature.name == featureName && feature.isEnabled);
  }
}

