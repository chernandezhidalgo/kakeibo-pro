import 'package:flutter_test/flutter_test.dart';
import 'package:kakeibo_pro/features/csv/domain/parsers/bac_csv_parser.dart';

void main() {
  late BacCsvParser parser;

  setUp(() => parser = BacCsvParser());

  // ── canParse ────────────────────────────────────────────────────────────────

  group('canParse', () {
    test('reconoce CSV con encabezado BAC', () {
      const csv = 'Fecha,Descripción,Débito,Crédito,Saldo\n'
          '24/03/2026,SUPERMERCADO MAX,85000.00,,2200000.00';
      expect(parser.canParse(csv), isTrue);
    });

    test('rechaza CSV BN (tiene columna "Monto")', () {
      const csv = 'Fecha,Número,Descripción,Monto,Saldo\n'
          '24/03/2026,001,SUPER,-85000.00,2200000.00';
      expect(parser.canParse(csv), isFalse);
    });

    test('rechaza CSV sin columnas débito/crédito', () {
      const csv = 'Fecha,Descripción,Importe,Saldo\n'
          '24/03/2026,SUPER,-85000.00,2200000.00';
      expect(parser.canParse(csv), isFalse);
    });
  });

  // ── parse ───────────────────────────────────────────────────────────────────

  group('parse', () {
    test('parsea un débito como monto negativo', () {
      const csv = 'Fecha,Descripción,Débito,Crédito,Saldo\n'
          '24/03/2026,SUPERMERCADO MAX,85000.00,,2200000.00';
      final result = parser.parse(csv);
      expect(result.transactions.length, 1);
      expect(result.errors.isEmpty, isTrue);
      final tx = result.transactions.first;
      expect(tx.amount, -85000.00);
      expect(tx.description, 'SUPERMERCADO MAX');
      expect(tx.date, DateTime(2026, 3, 24));
    });

    test('parsea un crédito como monto positivo', () {
      const csv = 'Fecha,Descripción,Débito,Crédito,Saldo\n'
          '24/03/2026,PAGO SINPE MOVIL,,150000.00,2350000.00';
      final result = parser.parse(csv);
      expect(result.transactions.first.amount, 150000.00);
    });

    test('parsea múltiples filas con débitos y créditos mezclados', () {
      const csv = 'Fecha,Descripción,Débito,Crédito,Saldo\n'
          '24/03/2026,SUPER,85000.00,,2200000.00\n'
          '23/03/2026,PAGO SINPE,,150000.00,2285000.00\n'
          '22/03/2026,FARMACIA,12000.00,,2135000.00';
      final result = parser.parse(csv);
      expect(result.transactions.length, 3);
      expect(result.transactions[0].amount, -85000.00);
      expect(result.transactions[1].amount, 150000.00);
      expect(result.transactions[2].amount, -12000.00);
    });

    test('registra error cuando no hay débito ni crédito', () {
      const csv = 'Fecha,Descripción,Débito,Crédito,Saldo\n'
          '24/03/2026,MISTERIO,,,2200000.00';
      final result = parser.parse(csv);
      expect(result.errors.isNotEmpty, isTrue);
      expect(result.transactions.isEmpty, isTrue);
    });

    test('registra error con columnas insuficientes', () {
      const csv = 'Fecha,Descripción,Débito,Crédito,Saldo\n'
          '24/03/2026,INCOMPLETA';
      final result = parser.parse(csv);
      expect(result.errors.isNotEmpty, isTrue);
    });

    test('bankName es "BAC San José"', () {
      expect(parser.bankName, 'BAC San José');
    });
  });
}
