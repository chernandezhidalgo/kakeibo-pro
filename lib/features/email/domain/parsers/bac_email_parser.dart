import 'package:kakeibo_pro/features/email/domain/models/bank_email.dart';

/// Parser para correos del BAC Credomatic.
class BacEmailParser {
  static const _sender = 'notificaciones@baccredomatic.com';

  static bool canParse(String from) =>
      from.toLowerCase().contains('baccredomatic') ||
      from.toLowerCase().contains('bac ') ||
      from.toLowerCase().contains(_sender);

  /// Extrae datos de transacción del cuerpo del correo BAC.
  static BankEmail parse({
    required String id,
    required String subject,
    required String from,
    required DateTime date,
    required String body,
  }) {
    double? amount;
    String? merchant;
    String? description;

    // BAC usa patrones como "Monto: USD 45.00" o "Monto CRC: 5,000.00"
    final amountMatch = RegExp(
      r'[Mm]onto(?:\s+(?:CRC|USD|₡))?\s*:?\s*(?:CRC|USD|₡)?\s*([\d,\.]+)',
    ).firstMatch(body);
    if (amountMatch != null) {
      final raw = amountMatch.group(1)!.replaceAll(',', '');
      amount = double.tryParse(raw);
    }

    // BAC suele incluir "En: NOMBRE COMERCIO"
    final merchantMatch = RegExp(
      r'[Ee]n[:\s]+([A-Z][^\n\r]{2,40})',
    ).firstMatch(body);
    if (merchantMatch != null) {
      merchant = merchantMatch.group(1)?.trim();
    }

    description = subject
        .replaceAll(
          RegExp(r'notificaci[oó]n|alerta|bac|credomatic',
              caseSensitive: false),
          '',
        )
        .trim();

    return BankEmail(
      id: id,
      subject: subject,
      from: from,
      date: date,
      amount: amount,
      merchant: merchant,
      description: description.isNotEmpty ? description : 'Pago con tarjeta BAC',
      rawBody: body,
      isParsed: amount != null,
    );
  }
}
