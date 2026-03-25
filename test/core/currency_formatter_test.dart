import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakeibo_pro/core/utils/currency_formatter.dart';

void main() {
  // Los formatters de intl necesitan datos de localización inicializados.
  setUpAll(() async {
    await initializeDateFormatting('es_CR');
    await initializeDateFormatting('en_US');
  });

  group('CurrencyFormatter.format (CRC por defecto)', () {
    test('formatea cero', () {
      final result = CurrencyFormatter.format(0);
      expect(result, contains('₡'));
      expect(result, contains('0'));
    });

    test('formatea monto positivo con símbolo colón', () {
      final result = CurrencyFormatter.format(85000);
      expect(result, contains('₡'));
      // El valor numérico debe estar presente (con o sin separadores de miles)
      expect(result.replaceAll(RegExp(r'[^\d]'), ''), contains('85000'));
    });

    test('formatea monto negativo', () {
      final result = CurrencyFormatter.format(-50000);
      expect(result, contains('₡'));
      // Debe haber un símbolo negativo
      expect(result.contains('-') || result.contains('('), isTrue);
    });
  });

  group('CurrencyFormatter.format (USD)', () {
    test('formatea en dólares con símbolo \$', () {
      final result = CurrencyFormatter.format(99.99, currency: 'USD');
      expect(result, contains('\$'));
      expect(result, contains('99'));
    });

    test('case-insensitive para la clave de moneda', () {
      final lower = CurrencyFormatter.format(100, currency: 'usd');
      final upper = CurrencyFormatter.format(100, currency: 'USD');
      expect(lower, equals(upper));
    });
  });

  group('CurrencyFormatter.formatCompact', () {
    test('formatea millones con sufijo M', () {
      final result = CurrencyFormatter.formatCompact(2500000);
      expect(result, contains('M'));
    });

    test('formatea miles con sufijo k', () {
      final result = CurrencyFormatter.formatCompact(85000);
      expect(result.toLowerCase(), contains('k'));
    });

    test('formatea valores pequeños como número normal', () {
      final result = CurrencyFormatter.formatCompact(500);
      expect(result, isNot(contains('M')));
      expect(result, isNot(anyOf(contains('k'), contains('K'))));
    });
  });
}
