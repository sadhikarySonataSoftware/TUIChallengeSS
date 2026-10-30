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
  void onError(DioException error, ErrorInterceptorHandler handler) {
    AppLogger.error(
      '✕ ${error.requestOptions.method} ${error.requestOptions.uri}\n'
      '  type=${error.type}\n'
      '  status=${error.response?.statusCode}\n'
      '  message=${error.message}\n'
      '  response=${_summarize(error.response?.data)}',
      error: error,
      stackTrace: error.stackTrace,
      tag: 'HTTP',
    );
    handler.next(error);
  }

  String _summarize(dynamic value) {
    final text = value?.toString() ?? '<null>';
    const maxLength = 4000;
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}… [truncated ${text.length - maxLength} chars]';
  }
}
