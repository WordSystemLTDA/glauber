import 'package:dio/dio.dart';
import 'package:provadelaco/config/config.dart';

class DioClient {
  final dio = Dio(
    BaseOptions(
      baseUrl: ConstantesGlobal.apiUrl,
      connectTimeout: const Duration(minutes: 10),
    ),
  );
}
