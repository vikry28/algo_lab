import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'PROJECT_ID', obfuscate: true)
  static final String projectId = _Env.projectId;

  @EnviedField(varName: 'WEB_CLIENT_ID', obfuscate: true)
  static final String webClientId = _Env.webClientId;

  @EnviedField(varName: 'STORAGE_BUCKET', obfuscate: true)
  static final String storageBucket = _Env.storageBucket;

  // Android
  @EnviedField(varName: 'ANDROID_API_KEY', obfuscate: true)
  static final String androidApiKey = _Env.androidApiKey;

  @EnviedField(varName: 'ANDROID_APP_ID', obfuscate: true)
  static final String androidAppId = _Env.androidAppId;

  @EnviedField(varName: 'ANDROID_MESSAGING_SENDER_ID', obfuscate: true)
  static final String androidMessagingSenderId = _Env.androidMessagingSenderId;

  // iOS
  @EnviedField(varName: 'IOS_API_KEY', obfuscate: true)
  static final String iosApiKey = _Env.iosApiKey;

  @EnviedField(varName: 'IOS_APP_ID', obfuscate: true)
  static final String iosAppId = _Env.iosAppId;

  @EnviedField(varName: 'IOS_MESSAGING_SENDER_ID', obfuscate: true)
  static final String iosMessagingSenderId = _Env.iosMessagingSenderId;

  @EnviedField(varName: 'IOS_BUNDLE_ID', obfuscate: true)
  static final String iosBundleId = _Env.iosBundleId;
}
