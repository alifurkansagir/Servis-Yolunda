import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vehicle.dart';

class ApiService {
  // 10.0.2.2 maps to localhost of host machine in Android Emulator
  // 127.0.0.1 maps to localhost of host machine in iOS Simulator
  static const String baseUrl = 'http://127.0.0.1:3005/api/vehicles';
  static const String androidBaseUrl = 'http://10.0.2.2:3005/api/vehicles';

  static Future<List<Vehicle>> fetchVehicles({String? factoryCode}) async {
    String url = baseUrl;
    if (factoryCode != null && factoryCode.isNotEmpty) {
      url += '?factoryCode=$factoryCode';
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return _parseResponse(response.body);
      }
    } catch (e) {
      // Fallback for Android emulator
      try {
        String urlAnd = androidBaseUrl;
        if (factoryCode != null && factoryCode.isNotEmpty) {
          urlAnd += '?factoryCode=$factoryCode';
        }
        final responseAnd = await http.get(Uri.parse(urlAnd));
        if (responseAnd.statusCode == 200) {
          return _parseResponse(responseAnd.body);
        }
      } catch (innerE) {
        throw Exception('Failed to load vehicles from API');
      }
    }
    throw Exception('Failed to load vehicles');
  }

  static List<Vehicle> _parseResponse(String body) {
    final parsed = json.decode(body);
    if (parsed['success'] == true) {
      final data = parsed['data'] as List;
      return data.map((v) => Vehicle.fromJson(v)).toList();
    }
    return [];
  }
}
