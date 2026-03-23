import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Tipología de fallos de dominio en KakeiboPro.
///
/// Usar pattern matching con `switch(failure) { ... }` para gestión
/// exhaustiva en la capa de presentación.
@freezed
sealed class Failure with _$Failure {
  const factory Failure.auth(String message) = AuthFailure;
  const factory Failure.network(String message) = NetworkFailure;
  const factory Failure.database(String message) = DatabaseFailure;
  const factory Failure.biometric(String message) = BiometricFailure;
}

/// Valor nulo explícito para operaciones sin datos de retorno significativo.
///
/// Reemplaza `void` como parámetro de tipo en [AuthResult] para evitar
/// ambigüedades con `T? data == null` en operaciones exitosas vs fallidas.
final class Unit {
  const Unit._();
  static const Unit value = Unit._();
}

/// Alias tipado para resultados de operaciones de autenticación.
///
/// Convención:
/// - Éxito  → `(data: valor, failure: null)`
/// - Fallo  → `(data: null, failure: AuthFailure(...))`
///
/// Verificar éxito: `result.failure == null`
typedef AuthResult<T> = ({T? data, AuthFailure? failure});
