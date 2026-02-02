import 'package:crypto_mobil/core/di/injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: true)
Future<void> configureDependencies() async {
  await getIt.init();
}

// Module for external dependencies
@module
abstract class ExternalModule {
  @lazySingleton
  Logger get logger => Logger(
    printer: PrettyPrinter(methodCount: 0, errorMethodCount: 5, lineLength: 50),
  );
}
