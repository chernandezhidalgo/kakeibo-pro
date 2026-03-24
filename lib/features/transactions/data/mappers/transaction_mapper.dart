import 'package:drift/drift.dart';
import 'package:kakeibo_pro/core/database/app_database.dart';
import 'package:kakeibo_pro/features/transactions/domain/entities/transaction.dart';

/// Extensión sobre la fila Drift para convertir al modelo de dominio.
extension TransactionMapper on TransactionsTableData {
  Transaction toDomain() {
    return Transaction(
      id: id,
      familyId: familyId,
      envelopeId: envelopeId,
      accountId: null, // no persiste en DB local en esta versión
      registeredBy: createdByUserId,
      amount: amount,
      currency: currency,
      description: description,
      merchantName: merchant,
      transactionDate: transactionDate,
      transactionType: _typeFromString(type),
      status: TransactionStatus.confirmed,
      source: _sourceFromString(sourceType),
      confidenceScore: 1.0,
    );
  }

  TransactionType _typeFromString(String value) {
    return switch (value) {
      'expense' => TransactionType.expense,
      'income' => TransactionType.income,
      'transfer' => TransactionType.transfer,
      'investment' => TransactionType.investment,
      _ => TransactionType.expense, // fallback seguro
    };
  }

  TransactionSource _sourceFromString(String? value) {
    return switch (value) {
      'csv_import' => TransactionSource.csvImport,
      'email_detection' => TransactionSource.emailDetection,
      'ocr' => TransactionSource.ocr,
      'recurring' => TransactionSource.recurring,
      _ => TransactionSource.manual,
    };
  }
}

/// Extensión sobre el modelo de dominio para convertir al formato Drift.
extension TransactionDomainMapper on Transaction {
  /// Genera el companion Drift para operaciones INSERT/UPDATE.
  TransactionsTableCompanion toCompanion() {
    return TransactionsTableCompanion(
      id: Value(id),
      familyId: Value(familyId),
      envelopeId: Value(envelopeId),
      createdByUserId: Value(registeredBy),
      type: Value(_typeToString(transactionType)),
      amount: Value(amount),
      currency: Value(currency),
      description: Value(description),
      merchant: Value(merchantName),
      transactionDate: Value(transactionDate),
      sourceType: Value(_sourceToString(source)),
      isSynced: const Value(false),
      updatedAt: Value(DateTime.now()),
    );
  }

  /// Genera el payload JSON para enqueue en [SyncQueueTable].
  /// Las claves siguen el esquema snake_case de Supabase.
  Map<String, dynamic> toSyncPayload() {
    return {
      'id': id,
      'family_id': familyId,
      'envelope_id': envelopeId,
      'created_by_user_id': registeredBy,
      'type': _typeToString(transactionType),
      'amount': amount,
      'currency': currency,
      'description': description,
      'merchant': merchantName,
      'transaction_date': transactionDate.toIso8601String(),
      'source_type': _sourceToString(source),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  String _typeToString(TransactionType t) {
    return switch (t) {
      TransactionType.expense => 'expense',
      TransactionType.income => 'income',
      TransactionType.transfer => 'transfer',
      TransactionType.investment => 'investment',
    };
  }

  String _sourceToString(TransactionSource s) {
    return switch (s) {
      TransactionSource.manual => 'manual',
      TransactionSource.csvImport => 'csv_import',
      TransactionSource.emailDetection => 'email_detection',
      TransactionSource.ocr => 'ocr',
      TransactionSource.recurring => 'recurring',
    };
  }
}
