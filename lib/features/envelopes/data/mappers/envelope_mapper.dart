import 'package:drift/drift.dart';
import 'package:kakeibo_pro/core/database/app_database.dart';
import 'package:kakeibo_pro/features/envelopes/domain/entities/envelope.dart';

/// Extensión sobre la fila Drift para convertir al modelo de dominio.
extension EnvelopeMapper on EnvelopesTableData {
  Envelope toDomain() {
    return Envelope(
      id: id,
      familyId: familyId,
      name: name,
      kakeiboCategory: _categoryFromString(category),
      monthlyBudget: budgetedAmount,
      currentSpent: spentAmount,
      colorHex: colorHex ?? '#5b9cf6',
      iconEmoji: iconCode ?? '💰',
      sortOrder: sortOrder,
      isActive: isActive,
      isEditable: true, // todos los sobres locales son editables
    );
  }

  KakeiboCategory _categoryFromString(String value) {
    return switch (value) {
      'survival' => KakeiboCategory.survival,
      'culture' => KakeiboCategory.culture,
      'leisure' => KakeiboCategory.leisure,
      'extras' => KakeiboCategory.extras,
      'investment' => KakeiboCategory.investment,
      'allowance' => KakeiboCategory.allowance,
      _ => KakeiboCategory.extras, // fallback seguro
    };
  }
}

/// Extensión sobre el modelo de dominio para convertir al formato Drift.
extension EnvelopeDomainMapper on Envelope {
  /// Genera el companion Drift para operaciones INSERT/UPDATE.
  EnvelopesTableCompanion toCompanion() {
    return EnvelopesTableCompanion(
      id: Value(id),
      familyId: Value(familyId),
      name: Value(name),
      category: Value(_categoryToString(kakeiboCategory)),
      budgetedAmount: Value(monthlyBudget),
      spentAmount: Value(currentSpent),
      colorHex: Value(colorHex),
      iconCode: Value(iconEmoji),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
      isSynced: const Value(false), // toda escritura local empieza sin sync
      updatedAt: Value(DateTime.now()),
    );
  }

  /// Genera el payload JSON para enqueue en [SyncQueueTable].
  /// Las claves siguen el esquema snake_case de Supabase.
  Map<String, dynamic> toSyncPayload() {
    return {
      'id': id,
      'family_id': familyId,
      'name': name,
      'category': _categoryToString(kakeiboCategory),
      'budgeted_amount': monthlyBudget,
      'spent_amount': currentSpent,
      'color_hex': colorHex,
      'icon_code': iconEmoji,
      'sort_order': sortOrder,
      'is_active': isActive,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  String _categoryToString(KakeiboCategory cat) {
    return switch (cat) {
      KakeiboCategory.survival => 'survival',
      KakeiboCategory.culture => 'culture',
      KakeiboCategory.leisure => 'leisure',
      KakeiboCategory.extras => 'extras',
      KakeiboCategory.investment => 'investment',
      KakeiboCategory.allowance => 'allowance',
    };
  }
}
