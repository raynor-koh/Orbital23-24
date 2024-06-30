import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'ALPACA_API_KEY')
  static String apiKey = _Env.apiKey;

  @EnviedField(varName: 'ALPACA_API_SECRET')
  static String apiSecret = _Env.apiSecret;
}
