import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/models/trip.dart';
import 'package:move_together_app/core/services/api.dart';

class TripService {
  final api = Api().dio;
  final AuthProvider authProvider;

  TripService(
    this.authProvider,
  );

  Future<Trip> joinTrip(String inviteCode) async {
    final response = await api.post('/trips/join?inviteCode=$inviteCode');

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return Trip.fromJson(response.data);
    } else {
      throw Exception('Failed to join trip');
    }
  }
}