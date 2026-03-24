import 'package:intl/intl.dart';

/// Formatea montos en CRC y USD para mostrar en la UI.
class CurrencyFormatter {
  CurrencyFormatter._();

  static final _crcFormatter = NumberFormat.currency(
    locale: 'es_CR',
    symbol: '₡',
    decimalDigits: 0,
  );

  static final _usdFormatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );

  /// Formatea un monto según la moneda. Por defecto CRC.
  static String format(double amount, {String currency = 'CRC'}) {
    return switch (currency.toUpperCase()) {
      'USD' => _usdFormatter.format(amount),
      _ => _crcFormatter.format(amount),
    };
  }

  /// Formatea el número de forma compacta sin símbolo de moneda.
  static String formatCompact(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    }
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
