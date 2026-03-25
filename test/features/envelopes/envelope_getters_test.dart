import 'package:flutter_test/flutter_test.dart';
import 'package:kakeibo_pro/features/envelopes/domain/entities/envelope.dart';

// Helper para construir un [Envelope] mínimo con los campos que interesan al test.
Envelope _makeEnvelope({
  required double monthlyBudget,
  required double currentSpent,
}) {
  return Envelope(
    id: 'test-id',
    familyId: 'family-id',
    name: 'Test',
    kakeiboCategory: KakeiboCategory.survival,
    monthlyBudget: monthlyBudget,
    currentSpent: currentSpent,
    sortOrder: 0,
    isActive: true,
    isEditable: true,
  );
}

void main() {
  group('EnvelopeGetters.remainingBudget', () {
    test('devuelve la diferencia positiva cuando no se excedió', () {
      final env = _makeEnvelope(monthlyBudget: 100000, currentSpent: 40000);
      expect(env.remainingBudget, 60000);
    });

    test('devuelve valor negativo cuando se excedió el presupuesto', () {
      final env = _makeEnvelope(monthlyBudget: 50000, currentSpent: 65000);
      expect(env.remainingBudget, -15000);
    });

    test('devuelve cero cuando gasto igual a presupuesto', () {
      final env = _makeEnvelope(monthlyBudget: 80000, currentSpent: 80000);
      expect(env.remainingBudget, 0);
    });
  });

  group('EnvelopeGetters.spentPercentage', () {
    test('calcula porcentaje correctamente', () {
      final env = _makeEnvelope(monthlyBudget: 200000, currentSpent: 50000);
      expect(env.spentPercentage, 25.0);
    });

    test('puede superar 100 cuando se excede el presupuesto', () {
      final env = _makeEnvelope(monthlyBudget: 100000, currentSpent: 130000);
      expect(env.spentPercentage, 130.0);
    });

    test('devuelve 0 cuando el presupuesto es 0', () {
      final env = _makeEnvelope(monthlyBudget: 0, currentSpent: 5000);
      expect(env.spentPercentage, 0.0);
    });

    test('devuelve 0 cuando no se ha gastado nada', () {
      final env = _makeEnvelope(monthlyBudget: 100000, currentSpent: 0);
      expect(env.spentPercentage, 0.0);
    });
  });

  group('EnvelopeGetters.isOverBudget', () {
    test('false cuando gasto menor al presupuesto', () {
      final env = _makeEnvelope(monthlyBudget: 100000, currentSpent: 99999);
      expect(env.isOverBudget, isFalse);
    });

    test('false cuando gasto igual al presupuesto (no lo supera)', () {
      final env = _makeEnvelope(monthlyBudget: 100000, currentSpent: 100000);
      expect(env.isOverBudget, isFalse);
    });

    test('true cuando gasto supera el presupuesto', () {
      final env = _makeEnvelope(monthlyBudget: 100000, currentSpent: 100001);
      expect(env.isOverBudget, isTrue);
    });
  });
}
