import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getAddressFromCoordinates(
  double latitude,
  double longitude,
) async {
  final apiKey = '';
  final url =
      'https://api.opencagedata.com/geocode/v1/json?q=$latitude+$longitude&key=$apiKey';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final city = data['results'][0]['components']['city'] ?? 'Unknown';
      return city;
    } else {
      return "Failed to retrieve address";
    }
  } catch (e) {
    print("Error getting address: $e");
    return "Error retrieving address.";
  }
}
