import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MavtraAPIService {
  late Dio _dio;
  String _baseURL;
  Map<String, dynamic>? defaultCredentials;
  static const String _baseUrlKey = 'api_base_url';

  MavtraAPIService({
    required String baseURL,
    this.defaultCredentials,
    int? connectTimeout,
    int? receiveTimeout,
    int? sendTimeout,
  }) : _baseURL = baseURL {
    _initializeDio(
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
    );
  }

  /// Initialize Dio with current base URL
  void _initializeDio({
    int? connectTimeout,
    int? receiveTimeout,
    int? sendTimeout,
  }) {
    _dio = Dio(BaseOptions(
      baseUrl: _baseURL,
      connectTimeout: Duration(milliseconds: connectTimeout ?? 30000), // 30 seconds
      receiveTimeout: Duration(milliseconds: receiveTimeout ?? 30000), // 30 seconds
      sendTimeout: Duration(milliseconds: sendTimeout ?? 30000), // 30 seconds
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Add interceptors
    _setupInterceptors();
  }

  /// Update base URL and reinitialize Dio
  Future<void> updateBaseUrl(String newBaseUrl) async {
    if (_baseURL != newBaseUrl) {
      _baseURL = newBaseUrl;

      // Save to SharedPreferences
      await _saveBaseUrl(newBaseUrl);

      // Reinitialize Dio with new base URL
      _initializeDio();

      print('🔄 API Base URL updated to: $newBaseUrl');
    }
  }

  /// Save base URL to SharedPreferences
  Future<void> _saveBaseUrl(String baseUrl) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_baseUrlKey, baseUrl);
    } catch (e) {
      print('Error saving base URL: $e');
    }
  }

  /// Get current base URL
  String get baseURL => _baseURL;

  /// Setup Dio interceptors for logging and error handling
  void _setupInterceptors() {
    // Clear existing interceptors
    _dio.interceptors.clear();

    // Request interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('🚀 REQUEST: ${options.method} ${options.path}');
        print('📤 Data: ${options.data}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
        print('📥 Data: ${response.data}');
        handler.next(response);
      },
      onError: (error, handler) {
        print('❌ ERROR: ${error.message}');
        print('📍 Path: ${error.requestOptions.path}');
        if (error.response != null) {
          print('📥 Error Data: ${error.response?.data}');
        }
        handler.next(error);
      },
    ));
  }

  /// Generic POST request with JSON-RPC 2.0 format
  /// [endpoint] - API endpoint path
  /// [params] - Request parameters
  /// [options] - Additional Dio options
  Future<Map<String, dynamic>> post(
      String endpoint, {
        Map<String, dynamic>? params,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      // Merge default credentials with provided params
      final Map<String, dynamic> requestParams = {
        ...?defaultCredentials,
        ...?params,
      };

      // Build JSON-RPC 2.0 request body
      final requestBody = {
        'jsonrpc': '2.0',
        'params': requestParams,
      };

      final response = await _dio.post(
        endpoint,
        data: requestBody,
        options: options,
        cancelToken: cancelToken,
      );

      if (response.data is Map<String, dynamic>) {
        return response.data;
      } else {
        return {'data': response.data};
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (error) {
      print('API Request Error: $error');
      throw APIException('Unexpected error occurred: $error');
    }
  }

  /// Generic GET request
  Future<Map<String, dynamic>> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      if (response.data is Map<String, dynamic>) {
        return response.data;
      } else {
        return {'data': response.data};
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (error) {
      throw APIException('Unexpected error occurred: $error');
    }
  }

  /// Generic PUT request
  Future<Map<String, dynamic>> put(
      String endpoint, {
        Map<String, dynamic>? data,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        options: options,
        cancelToken: cancelToken,
      );

      if (response.data is Map<String, dynamic>) {
        return response.data;
      } else {
        return {'data': response.data};
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (error) {
      throw APIException('Unexpected error occurred: $error');
    }
  }

  /// Generic DELETE request
  Future<Map<String, dynamic>> delete(
      String endpoint, {
        Map<String, dynamic>? data,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        options: options,
        cancelToken: cancelToken,
      );

      if (response.data is Map<String, dynamic>) {
        return response.data;
      } else {
        return {'data': response.data};
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (error) {
      throw APIException('Unexpected error occurred: $error');
    }
  }

  /// Upload file with form data
  Future<Map<String, dynamic>> uploadFile(
      String endpoint,
      String filePath, {
        Map<String, dynamic>? additionalParams,
        ProgressCallback? onSendProgress,
        CancelToken? cancelToken,
      }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
        ...?additionalParams,
      });

      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );

      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Download file
  Future<void> downloadFile(
      String url,
      String savePath, {
        ProgressCallback? onReceiveProgress,
        CancelToken? cancelToken,
      }) async {
    try {
      await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Handle Dio errors and convert them to APIException
  APIException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return APIException('Connection timeout', 408);
      case DioExceptionType.sendTimeout:
        return APIException('Send timeout', 408);
      case DioExceptionType.receiveTimeout:
        return APIException('Receive timeout', 408);
      case DioExceptionType.badResponse:
        return APIException(
          'Server error: ${error.response?.statusMessage ?? 'Unknown error'}',
          error.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return APIException('Request cancelled');
      case DioExceptionType.connectionError:
        return APIException('Connection error. Please check your internet connection');
      case DioExceptionType.badCertificate:
        return APIException('Certificate error');
      default:
        return APIException('Network error: ${error.message}');
    }
  }

  /// Set default credentials for all requests
  void setDefaultCredentials(Map<String, dynamic> credentials) {
    defaultCredentials = credentials;
  }

  /// Update specific credential field
  void updateCredential(String key, dynamic value) {
    defaultCredentials ??= {};
    defaultCredentials![key] = value;
  }

  /// Clear default credentials
  void clearCredentials() {
    defaultCredentials = null;
  }

  /// Add authorization header
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remove authorization header
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Add custom header
  void addHeader(String key, String value) {
    _dio.options.headers[key] = value;
  }

  /// Remove custom header
  void removeHeader(String key) {
    _dio.options.headers.remove(key);
  }

  /// Get Dio instance for advanced usage
  Dio get dioInstance => _dio;
}

/// Custom exception class for API errors
class APIException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  APIException(this.message, [this.statusCode, this.data]);

  @override
  String toString() => 'APIException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Singleton pattern for API service
class APIServiceSingleton {
  static MavtraAPIService? _instance;
  static const String _baseUrlKey = 'api_base_url';
  static const String _defaultBaseUrl = 'https://default.mavtra.com';

  static MavtraAPIService get instance {
    if (_instance == null) {
      throw Exception('APIService not initialized. Call initialize() first.');
    }
    return _instance!;
  }

  /// Initialize with saved base URL or provided URL
  static Future<void> initialize({
    String? baseURL,
    Map<String, dynamic>? defaultCredentials,
    int? connectTimeout,
    int? receiveTimeout,
    int? sendTimeout,
  }) async {
    String finalBaseUrl;

    if (baseURL != null) {
      // Use provided base URL (typically during login)
      finalBaseUrl = baseURL;
    } else {
      // Load from SharedPreferences or use default
      finalBaseUrl = await _getSavedBaseUrl();
    }

    _instance = MavtraAPIService(
      baseURL: finalBaseUrl,
      defaultCredentials: defaultCredentials,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
    );

    print('🚀 APIService initialized with base URL: $finalBaseUrl');
  }

  /// Get saved base URL from SharedPreferences
  static Future<String> _getSavedBaseUrl() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_baseUrlKey) ?? _defaultBaseUrl;
    } catch (e) {
      print('Error loading saved base URL: $e');
      return _defaultBaseUrl;
    }
  }

  /// Update base URL (typically called during login)
  static Future<void> updateBaseUrl(String newBaseUrl) async {
    if (_instance != null) {
      await _instance!.updateBaseUrl(newBaseUrl);
    } else {
      // If not initialized, initialize with the new URL
      await initialize(baseURL: newBaseUrl);
    }
  }

  /// Get saved base URL without initializing the service
  static Future<String> getSavedBaseUrl() async {
    return await _getSavedBaseUrl();
  }

  /// Check if service is initialized
  static bool get isInitialized => _instance != null;

  /// Get current base URL
  static String? get currentBaseUrl => _instance?.baseURL;
}