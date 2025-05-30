import 'package:dio/dio.dart';

import 'api_service.dart';

/// Authentication Service - Handles all auth-related API calls
class AuthService {
  final MavtraAPIService _apiService = APIServiceSingleton.instance;
  CancelToken? _cancelToken;

  /// Login/Authentication request
  Future<Map<String, dynamic>> login({
    required String url,
    required String login,
    required String password,
    required String appType,
    required String firebaseToken,
  }) async {
    try {
      url = "http://$url";
      // Cancel previous login request if still ongoing
      _cancelToken?.cancel('New login request');
      _cancelToken = CancelToken();

      // Update API service base URL if provided URL is different from current
      if (url.isNotEmpty && url != _apiService.baseURL) {
        await _apiService.updateBaseUrl(url);
        print('🔄 Updated API base URL to: $url');
      }

      final params = {
        'login': login,
        'password': password,
        'app_type': appType,
        'firebase_token': firebaseToken,
      };

      final response = await _apiService.post(
        '/json-call/user_authenticate',
        params: params,
        cancelToken: _cancelToken,
      );

      // If login successful, store the auth token
      if (response['token'] != null) {
        _apiService.setAuthToken(response['token']);
      }

      return response;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        throw APIException('Login cancelled');
      }
      rethrow;
    } on APIException catch (e) {
      print('Authentication failed: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error during authentication: $e');
      throw APIException('Authentication failed');
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await _apiService.post('/json-call/user_logout');
    } catch (e) {
      print('Logout API call failed: $e');
    } finally {
      // Always clear local tokens
      _apiService.clearAuthToken();
      _apiService.clearCredentials();
    }
  }
}
