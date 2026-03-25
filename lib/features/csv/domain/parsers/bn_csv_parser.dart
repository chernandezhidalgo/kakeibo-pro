import 'package:intl/intl.dart';

import '../models/csv_transaction.dart';
import 'base_csv_parser.dart';

/// Parser para archivos CSV del Banco Nacional de Costa Rica.
/// Soporta cuentas de ahorro y tarjetas de crédito (mismo formato).
///
/// Formato esperado:
///   Fecha,Número,Descripción,Monto,Saldo
///   24/03/2026,001,SUPERMERCADO BUEN PRECIO SA,-85000.00,2200000.00
class BnCsvParser extends BaseCsvParser {
  @override
  String get bankName => 'Banco Nacional';

  // El encabezado real del BN contiene estas columnas:
  static const _expectedHeader = ['fecha', 'número', 'descripción', 'monto', 'saldo'];

  @override
  bool canParse(String csvContent) {
    final lines = csvContent.split('\n');
    // Buscar la fila de encabezado en las primeras 5 líneas
    for (final line in lines.take(5)) {
      final lower = line.toLowerCase().replaceAll(' ', '');
      if (_expectedHeader.every((h) => lower.contains(h))) return true;
    }
    return false;
  }

  @override
  CsvParseResult parse(String csvContent) {
    final transactions = <CsvTransaction>[];
    final errors = <String>[];
    final lines = csvContent
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    // 1. Encontrar el índice de la fila de encabezado
    int headerIndex = -1;
    for (int i = 0; i < lines.length && i < 5; i++) {
      final lower = lines[i].toLowerCase().replaceAll(' ', '');
      if (_expectedHeader.every((h) => lower.contains(h))) {
        headerIndex = i;
        break;
      }
    }

    if (headerIndex == -1) {
      return CsvParseResult(
        transactions: [],
        errors: ['No se encontró el encabezado esperado del Banco Nacional'],
        bankName: bankName,
        totalRows: 0,
      );
    }

    // 2. Parsear las filas de datos (después del encabezado)
    final dataLines = lines.sublist(headerIndex + 1);
    final fmt = DateFormat('dd/MM/yyyy');

    for (int i = 0; i < dataLines.length; i++) {
      final line = dataLines[i];
      try {
        final cols = _splitCsvLine(line);
        if (cols.length < 4) {
          errors.add('Fila ${i + 1}: columnas insuficientes → $line');
          continue;
        }
        final date = fmt.parse(cols[0].trim());
        final description = cols[2].trim();

        // Remover separadores de miles y normalizar decimal
        final rawAmount = cols[3].trim().replaceAll(',', '').replaceAll(' ', '');
        final amount = double.parse(rawAmount);

        if (description.isEmpty) {
          errors.add('Fila ${i + 1}: descripción vacía → $line');
          continue;
        }

        transactions.add(CsvTransaction(
          date: date,
          description: description,
          amount: amount,
          rawLine: line,
          rowIndex: i + 1,
        ));
      } catch (e) {
        errors.add('Fila ${i + 1}: error de parseo → $e');
      }
    }

    return CsvParseResult(
      transactions: transactions,
      errors: errors,
      bankName: bankName,
      totalRows: dataLines.length,
    );
  }

  /// Divide una línea CSV respetando comillas.
  List<String> _splitCsvLine(String line) {
    final result = <String>[];
    final buf = StringBuffer();
    bool inQuotes = false;
    for (int i = 0; i < line.length; i++) {
      final ch = line[i];
      if (ch == '"') {
        inQuotes = !inQuotes;
      } else if (ch == ',' && !inQuotes) {
        result.add(buf.toString());
        buf.clear();
      } else {
        buf.write(ch);
      }
    }
    result.add(buf.toString());
    return result;
  }
}
