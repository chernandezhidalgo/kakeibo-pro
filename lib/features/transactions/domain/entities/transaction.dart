import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';

/// Tipo de movimiento financiero.
enum TransactionType {
  expense,
  income,
  transfer,
  investment,
}

/// Estado de confirmación de la transacción.
enum TransactionStatus {
  confirmed,
  pendingConfirmation,
  ignored,
}

/// Origen de captura de la transacción.
enum TransactionSource {
  manual,
  csvImport,
  emailDetection,
  ocr,
  recurring,
}

/// Entidad de dominio que representa una transacción financiera.
///
/// Inmutable gracias a [freezed].
@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String familyId,
    String? envelopeId,
    String? accountId,
    required String registeredBy,
    required double amount,
    @Default('CRC') String currency,
    required String description,
    String? merchantName,
    required DateTime transactionDate,
    required TransactionType transactionType,
    required TransactionStatus status,
    required TransactionSource source,
    int? dayOfWeek,
    int? weekOfMonth,
    String? emotionalTag,
    @Default(1.0) double confidenceScore,
  }) = _Transaction;
}
