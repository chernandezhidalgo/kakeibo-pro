/// Resultado del procesamiento OCR de un recibo.
class OcrResult {
  final String rawText;
  final double? amount;
  final String? merchant;
  final String? description;
  final DateTime? date;
  final bool isProcessed;

  const OcrResult({
    required this.rawText,
    this.amount,
    this.merchant,
    this.description,
    this.date,
    required this.isProcessed,
  });

  OcrResult copyWith({
    String? rawText,
    double? amount,
    String? merchant,
    String? description,
    DateTime? date,
    bool? isProcessed,
  }) =>
      OcrResult(
        rawText: rawText ?? this.rawText,
        amount: amount ?? this.amount,
        merchant: merchant ?? this.merchant,
        description: description ?? this.description,
        date: date ?? this.date,
        isProcessed: isProcessed ?? this.isProcessed,
      );
}
