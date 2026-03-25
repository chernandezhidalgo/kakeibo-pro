class AiCategorizationRequest {
  final String description;
  final String? merchantName;
  final double amount;
  final String currency;
  final List<EnvelopeOption> availableEnvelopes;

  const AiCategorizationRequest({
    required this.description,
    this.merchantName,
    required this.amount,
    required this.currency,
    required this.availableEnvelopes,
  });
}

class EnvelopeOption {
  final String id;
  final String name;
  final String category;
  final String emoji;

  const EnvelopeOption({
    required this.id,
    required this.name,
    required this.category,
    required this.emoji,
  });
}
