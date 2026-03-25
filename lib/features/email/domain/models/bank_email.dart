/// Representa un correo bancario ya parseado con datos de transacción.
class BankEmail {
  final String id;
  final String subject;
  final String from;
  final DateTime date;
  final double? amount;
  final String? merchant;
  final String? description;
  final String rawBody;
  final bool isParsed;

  const BankEmail({
    required this.id,
    required this.subject,
    required this.from,
    required this.date,
    this.amount,
    this.merchant,
    this.description,
    required this.rawBody,
    required this.isParsed,
  });
}
