import 'package:dio/dio.dart';
import 'package:namira_tester/core/constants/url_links.dart';

class SubscriptionRepository {
  final Dio _dio = Dio();



  Future<String?> fetchConfigs() async {
    try {
      final response = await _dio.get(UrlLinks.subscriptionUrl);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }

  }
}


