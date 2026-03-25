import 'package:flutter_test/flutter_test.dart';
import 'package:kakeibo_pro/features/csv/domain/parsers/bn_csv_parser.dart';

void main() {
  late BnCsvParser parser;

  setUp(() => parser = BnCsvParser());

  // ── canParse ────────────────────────────────────────────────────────────────

  group('canParse', () {
    test('reconoce CSV con encabezado BN', () {
      const csv = 'Fecha,Número,Descripción,Monto,Saldo\n'
          '24/03/2026,001,SUPERMERCADO,-85000.00,2200000.00';
      expect(parser.canParse(csv), isTrue);
    });

    test('rechaza CSV sin encabezado BN', () {
      const csv = 'Fecha,Descripción,Débito,Crédito,Saldo\n'
          '24/03/2026,SUPER,85000.00,,2200000.00';
      expect(parser.canParse(csv), isFalse);
    });

    test('es insensible a mayúsculas en el encabezado', () {
      const csv = 'FECHA,NÚMERO,DESCRIPCIÓN,MONTO,SALDO\n'
          '24/03/2026,001,PAGO,-5000.00,100000.00';
      expect(parser.canParse(csv), isTrue);
    });
  });

  // ── parse ───────────────────────────────────────────────────────────────────

  group('parse', () {
    test('parsea una fila de gasto correctamente', () {
      const csv = 'Fecha,Número,Descripción,Monto,Saldo\n'
          '24/03/2026,001,SUPERMERCADO BUEN PRECIO SA,-85000.00,2200000.00';
      final result = parser.parse(csv);
      expect(result.transactions.length, 1);
      expect(result.errors.isEmpty, isTrue);
      final tx = result.transactions.first;
      expect(tx.amount, -85000.00);
      expect(tx.description, 'SUPERMERCADO BUEN PRECIO SA');
      expect(tx.date, DateTime(2026, 3, 24));
    });

    test('parsea monto positivo (ingreso)', () {
      const csv = 'Fecha,Número,Descripción,Monto,Saldo\n'
          '01/03/2026,002,SALARIO MARZO,1500000.00,3700000.00';
      final result = parser.parse(csv);
      expect(result.transactions.first.amount, 1500000.00);
    });

    test('parsea múltiples filas', () {
      const csv = 'Fecha,Número,Descripción,Monto,Saldo\n'
          '24/03/2026,001,SUPER,-85000.00,2200000.00\n'
          '23/03/2026,002,FARMACIA,-12000.00,2285000.00\n'
          '01/03/2026,003,SALARIO,1500000.00,2297000.00';
      final result = parser.parse(csv);
      expect(result.transactions.length, 3);
      expect(result.errors.isEmpty, isTrue);
      expect(result.totalRows, 3);
    });

    test('ignora líneas en blanco dentro del CSV', () {
      const csv = 'Fecha,Número,Descripción,Monto,Saldo\n'
          '24/03/2026,001,SUPER,-85000.00,2200000.00\n'
          '\n'
          '23/03/2026,002,FARMACIA,-12000.00,2285000.00';
      final result = parser.parse(csv);
      expect(result.transactions.length, 2);
    });

    test('registra error cuando faltan columnas', () {
      const csv = 'Fecha,Número,Descripción,Monto,Saldo\n'
          '24/03/2026,INCOMPLETA';
      final result = parser.parse(csv);
      expect(result.errors.isNotEmpty, isTrue);
      expect(result.transactions.isEmpty, isTrue);
    });

    test('devuelve error cuando no hay encabezado BN', () {
      const csv = 'Fecha,Descripción,Débito,Crédito,Saldo\n'
          '24/03/2026,SUPER,85000.00,,2200000.00';
      final result = parser.parse(csv);
      expect(result.transactions.isEmpty, isTrue);
      expect(result.errors.isNotEmpty, isTrue);
    });

    test('bankName es "Banco Nacional"', () {
      expect(parser.bankName, 'Banco Nacional');
    });
  });
}
