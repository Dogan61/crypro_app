import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'API_BASE_URL', defaultValue: 'http://10.0.2.2:3000')
  static const String apiBaseUrl = _Env.apiBaseUrl;
  
  @EnviedField(varName: 'WS_BASE_URL', defaultValue: 'ws://10.0.2.2:3000')
  static const String wsBaseUrl = _Env.wsBaseUrl;
  
  @EnviedField(varName: 'ENABLE_LOGS', defaultValue: 'true')
  static const String enableLogs = _Env.enableLogs;
}
