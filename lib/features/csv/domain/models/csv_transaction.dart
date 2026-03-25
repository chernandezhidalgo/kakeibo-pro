/// Modelo que representa una fila CSV ya parseada y validada.
///
/// No es una Transaction de dominio todavía — es un DTO intermedio
/// que el usuario confirma antes de guardarlo en la DB.
class CsvTransaction {
  final DateTime date;
  final String description;
  final double amount; // positivo = ingreso, negativo = gasto
  final String rawLine; // línea original para debug
  final int rowIndex; // número de fila en el CSV

  const CsvTransaction({
    required this.date,
    required this.description,
    required this.amount,
    required this.rawLine,
    required this.rowIndex,
  });

  /// true si el monto es negativo (gasto).
  bool get isExpense => amount < 0;

  double get absoluteAmount => amount.abs();
}

/// Resultado del parseo completo de un archivo CSV.
class CsvParseResult {
  final List<CsvTransaction> transactions;
  final List<String> errors; // líneas que no se pudieron parsear
  final String bankName;
  final int totalRows;

  const CsvParseResult({
    required this.transactions,
    required this.errors,
    required this.bankName,
    required this.totalRows,
  });

  bool get hasErrors => errors.isNotEmpty;
  bool get isEmpty => transactions.isEmpty;
}
