import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:myquitbuddy/managers/tokenManager.dart';

class AppInterceptor {
  var dio = Dio();
  static const baseUrl = 'https://impact.dei.unipd.it/bwthw/';
  static const _refreshEndpoint = 'gate/v1/refresh/';

  AppInterceptor() {
    dio.options = BaseOptions(baseUrl: baseUrl);
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      final accessToken = await TokenManager.getAccessToken();
      if (accessToken != null) {
        options.headers.putIfAbsent(
            HttpHeaders.authorizationHeader, () => 'Bearer $accessToken');
      }
      handler.next(options);
    }, onError: (err, handler) async {
      if (err.response?.statusCode == HttpStatus.unauthorized) {
        final success = await refreshToken();
        if (!success) return;

        final accessToken = await TokenManager.getAccessToken();
        if (accessToken != null) {
          err.requestOptions.headers[HttpHeaders.authorizationHeader] =
              'Bearer $accessToken';
        }

        final opts = Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers);
        final reqOpts = err.requestOptions;
        final cloneReq = await dio.request(err.requestOptions.path,
            options: opts,
            data: reqOpts.data,
            queryParameters: reqOpts.queryParameters,
            cancelToken: reqOpts.cancelToken,
            onReceiveProgress: reqOpts.onReceiveProgress,
            onSendProgress: reqOpts.onSendProgress);
        return handler.resolve(cloneReq);
      }
    }));
    final options = CacheOptions(
      // A default store is required for interceptor.
      store: MemCacheStore(),
      // All subsequent fields are optional.
      // Default.
      policy: CachePolicy.request,
      // Returns a cached response on error but for statuses 401 & 403.
      // Also allows to return a cached response on network errors (e.g. offline usage).
      // Defaults to [null].
      hitCacheOnErrorExcept: [401, 403],
      // Overrides any HTTP directive to delete entry past this duration.
      // Useful only when origin server has no cache config or custom behaviour is desired.
      // Defaults to [null].
      maxStale: const Duration(days: 1),
      // Default. Allows 3 cache sets and ease cleanup.
      priority: CachePriority.normal,
      // Default. Body and headers encryption with your own algorithm.
      cipher: null,
      // Default. Key builder to retrieve requests.
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      // Default. Allows to cache POST requests.
      // Overriding [keyBuilder] is strongly recommended when [true].
      allowPostMethod: false,
    );
    dio.interceptors.add(DioCacheInterceptor(options: options));
  }

  Future<bool> refreshToken() async {
    final refreshToken = await TokenManager.getRefreshToken();
    final isTokenExpired = await TokenManager.isRefreshTokenExpired();
    if (refreshToken == null || isTokenExpired) {
      return false;
    }
    return await dio.post(_refreshEndpoint,
        data: {'refresh': refreshToken}).then((value) async {
      if (value.statusCode == HttpStatus.ok) {
        await TokenManager.saveTokens(value.data);
        return true;
      }
      return false;
    });
  }
}