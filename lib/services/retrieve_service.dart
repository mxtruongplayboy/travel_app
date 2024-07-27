import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:travel_app/models/retrieve_model.dart';

class RetrieveService {
  final String apiUrl = "https://481a-116-105-225-77.ngrok-free.app/retrieve/";

  Future<RetrieveResult> fetchRetrieveResult(String url, String type) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'url': url,
        'type': type,
      }),
    );

    if (response.statusCode == 200) {
      print('Response status: ${response.statusCode}');
      final responseBody = utf8.decode(response.bodyBytes);
      print('Response body: $responseBody');
      return RetrieveResult.fromJson(json.decode(responseBody));
    } else {
      print('Response status: ${response.statusCode}');
      final responseBody = utf8.decode(response.bodyBytes);
      print('Response body: $responseBody');
      throw Exception('Failed to retrieve data');
    }
  }
}
