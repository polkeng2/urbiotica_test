import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiMarker {
  String name;
  String latitude;
  String longitude;

  ApiMarker({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory ApiMarker.fromJson(Map<String, dynamic> json) {
    return ApiMarker(
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  static Future<String> getToken() async {
    final response = await http.get(
        Uri.parse('https://api.urbiotica.net/v2/auth/orgd93e9d/test/test'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load token');
    }
  }

  // getMarkers
  static Future<List<ApiMarker>> getMarkers() async {
    final token = await getToken();
    var newToken = token.replaceAll('"', '');
    final response = await http.get(
        Uri.parse(
            "https://api.urbiotica.net/v2/organisms/orgd93e9d/projects/prj65e514/spots"),
        headers: {"IDENTITY_KEY": newToken});

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((marker) => ApiMarker.fromJson(marker)).toList();
    } else {
      throw Exception('Failed to load markers');
    }
  }
}
