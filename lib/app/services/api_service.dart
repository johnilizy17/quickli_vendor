import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import '../config/app_config.dart';
import '../utils/app_logger.dart';

class ApiService extends GetxService {
  static ApiService get to => Get.find();

  late final Dio _dio;
  final _box = GetStorage();

  static const _accessKey  = 'vendor_access_token';
  static const _refreshKey = 'vendor_refresh_token';

  @override
  void onInit() {
    super.onInit();
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));
    _dio.interceptors.add(_AuthInterceptor(_box));
    appLog('ApiService: baseUrl=${AppConfig.baseUrl} env=${AppConfig.envName}');
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) =>
      _dio.get(path, queryParameters: queryParameters);

  Future<Response> post(String path, {dynamic data}) =>
      _dio.post(path, data: data);

  Future<Response> put(String path, {dynamic data}) =>
      _dio.put(path, data: data);

  Future<Response> patch(String path, {dynamic data}) =>
      _dio.patch(path, data: data);

  Future<Response> delete(String path) => _dio.delete(path);

  void setTokens({required String accessToken, required String refreshToken}) {
    _box.write(_accessKey, accessToken);
    _box.write(_refreshKey, refreshToken);
    _dio.options.headers['Authorization'] = 'Bearer $accessToken';
    appLog('ApiService: tokens saved');
  }

  void clearTokens() {
    _box.remove(_accessKey);
    _box.remove(_refreshKey);
    _dio.options.headers.remove('Authorization');
    appLog('ApiService: tokens cleared');
  }

  String? get accessToken  => _box.read<String>(_accessKey);
  String? get refreshToken => _box.read<String>(_refreshKey);

  /// Loads persisted tokens and injects them into Dio headers.
  /// Returns a non-null map when a valid access token exists.
  Future<Map<String, dynamic>?> loadTokens() async {
    final token = _box.read<String>(_accessKey);
    if (token == null || token.isEmpty) return null;
    _dio.options.headers['Authorization'] = 'Bearer $token';
    appLog('ApiService: token loaded from storage');
    return {'accessToken': token};
  }
}

class _AuthInterceptor extends Interceptor {
  final GetStorage _box;
  _AuthInterceptor(this._box);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _box.read<String>('vendor_access_token');
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    appLog('API [${err.response?.statusCode}] ${err.requestOptions.method} '
        '${err.requestOptions.path}');
    handler.next(err);
  }
}
