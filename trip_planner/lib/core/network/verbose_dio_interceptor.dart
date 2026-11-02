import 'package:dio/dio.dart';

import '../logging/app_logger.dart';

class VerboseDioInterceptor extends Interceptor {
  const VerboseDioInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.debug(
      '→ ${options.method} ${options.uri}\n'
      '  headers=${options.headers}\n'
      '  query=${options.queryParameters}'
      '${options.data == null ? '' : '\n  body=${options.data}'}',
      tag: 'HTTP',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    AppLogger.debug(
      '← ${response.statusCode} ${response.requestOptions.method} '
      '${response.requestOptions.uri}\n'
      '  response=${_summarize(response.data)}',
      tag: 'HTTP',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      '✕ ${err.requestOptions.method} ${err.requestOptions.uri}\n'
      '  type=${err.type}\n'
      '  status=${err.response?.statusCode}\n'
      '  message=${err.message}\n'
      '  response=${_summarize(err.response?.data)}',
      error: err,
      stackTrace: err.stackTrace,
      tag: 'HTTP',
    );
    handler.next(err);
  }

  String _summarize(dynamic value) {
    final text = value?.toString() ?? '<null>';
    const maxLength = 4000;
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}… [truncated ${text.length - maxLength} chars]';
  }
}
