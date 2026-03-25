import 'package:intl/intl.dart';

import '../models/csv_transaction.dart';
import 'base_csv_parser.dart';

/// Parser para archivos CSV del BAC San José.
///
/// Formato esperado (columnas Débito/Crédito separadas, sin columna Número):
///   Fecha,Descripción,Débito,Crédito,Saldo
///   24/03/2026,PAGO SINPE MOVIL,,150000.00,2350000.00
///   23/03/2026,SUPERMERCADO MAX,85000.00,,2200000.00
class BacCsvParser extends BaseCsvParser {
  @override
  String get bankName => 'BAC San José';

  static const _expectedHeader = ['fecha', 'descripción', 'débito', 'crédito'];

  @override
  bool canParse(String csvContent) {
    final lines = csvContent.split('\n');
    for (final line in lines.take(5)) {
      final lower = line.toLowerCase().replaceAll(' ', '');
      // BAC tiene débito y crédito separados; BN tiene "monto"
      if (_expectedHeader.every((h) => lower.contains(h)) && !lower.contains('monto')) {
        return true;
      }
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
        errors: ['No se encontró el encabezado del BAC San José'],
        bankName: bankName,
        totalRows: 0,
      );
    }

    final dataLines = lines.sublist(headerIndex + 1);
    final fmt = DateFormat('dd/MM/yyyy');

    for (int i = 0; i < dataLines.length; i++) {
      final line = dataLines[i];
      try {
        final cols = _splitCsvLine(line);
        // BAC: Fecha | Descripción | Débito | Crédito | Saldo
        if (cols.length < 4) {
          errors.add('Fila ${i + 1}: columnas insuficientes');
          continue;
        }
        final date = fmt.parse(cols[0].trim());
        final description = cols[1].trim();
        final debitoStr = cols[2].trim().replaceAll(',', '');
        final creditoStr = cols[3].trim().replaceAll(',', '');

        // Débito = salida (negativo), Crédito = entrada (positivo)
        double amount;
        if (debitoStr.isNotEmpty && debitoStr != '0') {
          amount = -(double.parse(debitoStr)); // gasto
        } else if (creditoStr.isNotEmpty && creditoStr != '0') {
          amount = double.parse(creditoStr); // ingreso
        } else {
          errors.add('Fila ${i + 1}: sin débito ni crédito');
          continue;
        }

        if (description.isEmpty) {
          errors.add('Fila ${i + 1}: descripción vacía');
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
        errors.add('Fila ${i + 1}: $e');
      }
    }

    return CsvParseResult(
      transactions: transactions,
      errors: errors,
      bankName: bankName,
      totalRows: dataLines.length,
    );
  }

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
