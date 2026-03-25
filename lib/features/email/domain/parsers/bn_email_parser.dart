import 'package:kakeibo_pro/features/email/domain/models/bank_email.dart';

/// Parser para correos del Banco Nacional de Costa Rica (BN).
class BnEmailParser {
  static const _sender = 'alertas@bncr.fi.cr';

  static bool canParse(String from) =>
      from.toLowerCase().contains(_sender) ||
      from.toLowerCase().contains('bncr') ||
      from.toLowerCase().contains('banco nacional');

  /// Extrae datos de transacción del cuerpo del correo BN.
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

    // Patrón: "Monto: ₡ 12,345.00" o "Monto: CRC 12345"
    final amountMatch = RegExp(
      r'[Mm]onto[:\s]+(?:₡|CRC|USD|\$)?\s*([\d,\.]+)',
    ).firstMatch(body);
    if (amountMatch != null) {
      final raw = amountMatch.group(1)!.replaceAll(',', '');
      amount = double.tryParse(raw);
    }

    // Patrón: "Comercio: WALMART ESCAZU" o "Establecimiento: ..."
    final merchantMatch = RegExp(
      r'(?:[Cc]omercio|[Ee]stablecimiento)[:\s]+([^\n\r]+)',
    ).firstMatch(body);
    if (merchantMatch != null) {
      merchant = merchantMatch.group(1)?.trim();
    }

    // Descripción = subject limpio
    description = subject
        .replaceAll(
          RegExp(r'alerta|notificaci[oó]n|banco nacional',
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
      description: description.isNotEmpty ? description : 'Compra con tarjeta',
      rawBody: body,
      isParsed: amount != null,
    );
  }
}
