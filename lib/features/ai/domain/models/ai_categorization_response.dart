class AiCategorizationResponse {
  final String envelopeId;
  final String envelopeName;
  final double confidence;
  final String reasoning;

  const AiCategorizationResponse({
    required this.envelopeId,
    required this.envelopeName,
    required this.confidence,
    required this.reasoning,
  });

  factory AiCategorizationResponse.fromJson(Map<String, dynamic> json) {
    return AiCategorizationResponse(
      envelopeId: json['envelope_id'] as String,
      envelopeName: json['envelope_name'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      reasoning: json['reasoning'] as String,
    );
  }
}

class AiReflectionInsight {
  final String summary;
  final List<String> suggestions;
  final String motivationalMessage;

  const AiReflectionInsight({
    required this.summary,
    required this.suggestions,
    required this.motivationalMessage,
  });

  factory AiReflectionInsight.fromJson(Map<String, dynamic> json) {
    return AiReflectionInsight(
      summary: json['summary'] as String,
      suggestions: List<String>.from(json['suggestions'] as List),
      motivationalMessage: json['motivational_message'] as String,
    );
  }
}
