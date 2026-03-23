import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';

/// Provider de la base de datos local.
///
/// Se inicializa en [main()] con [ProviderScope.overrides] para inyectar
/// la instancia real creada por [AppDatabase.open()].
///
/// Uso en providers:
/// ```dart
/// final db = ref.watch(appDatabaseProvider);
/// ```
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError(
    'appDatabaseProvider debe ser sobreescrito en main.dart con la instancia '
    'real. Asegúrate de usar ProviderScope(overrides: [appDatabaseProvider.overrideWithValue(db)]).',
  );
});
