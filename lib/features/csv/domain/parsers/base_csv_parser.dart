import '../models/csv_transaction.dart';

/// Contrato base para todos los parsers bancarios.
/// Cada banco implementa su propio parser concreto.
abstract class BaseCsvParser {
  String get bankName;

  /// Parsea el contenido de texto del CSV y retorna el resultado.
  /// Nunca lanza excepciones — los errores van en CsvParseResult.errors.
  CsvParseResult parse(String csvContent);

  /// Verifica si el contenido parece ser de este banco.
  /// Retorna true si el encabezado contiene las columnas esperadas.
  bool canParse(String csvContent);
}
