import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo_pro/features/csv/domain/models/csv_transaction.dart';
import 'package:kakeibo_pro/features/csv/domain/parsers/bn_csv_parser.dart';
import 'package:kakeibo_pro/features/csv/domain/parsers/bac_csv_parser.dart';
import 'package:kakeibo_pro/features/csv/domain/parsers/base_csv_parser.dart';
import 'package:kakeibo_pro/features/transactions/domain/entities/transaction.dart';
import 'package:kakeibo_pro/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:uuid/uuid.dart';

// ── Estado ────────────────────────────────────────────────────────────────────

enum CsvImportStep { idle, parsing, preview, importing, done, error }

class CsvImportState {
  final CsvImportStep step;
  final CsvParseResult? parseResult;

  /// Índices de filas seleccionadas para importar (por defecto todas).
  final Set<int> selectedRows;
  final int importedCount;
  final String? errorMessage;

  const CsvImportState({
    this.step = CsvImportStep.idle,
    this.parseResult,
    this.selectedRows = const {},
    this.importedCount = 0,
    this.errorMessage,
  });

  CsvImportState copyWith({
    CsvImportStep? step,
    CsvParseResult? parseResult,
    Set<int>? selectedRows,
    int? importedCount,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CsvImportState(
      step: step ?? this.step,
      parseResult: parseResult ?? this.parseResult,
      selectedRows: selectedRows ?? this.selectedRows,
      importedCount: importedCount ?? this.importedCount,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// ── Notifier ──────────────────────────────────────────────────────────────────

class CsvImportNotifier extends StateNotifier<CsvImportState> {
  final Ref _ref;
  final String familyId;
  final String envelopeId;
  final String registeredBy;

  CsvImportNotifier({
    required Ref ref,
    required this.familyId,
    required this.envelopeId,
    required this.registeredBy,
  })  : _ref = ref,
        super(const CsvImportState());

  // 1. Abrir selector de archivo y parsear
  Future<void> pickAndParse() async {
    state = state.copyWith(step: CsvImportStep.parsing, clearError: true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'txt'],
        withData: true, // necesario para web
      );

      if (result == null || result.files.isEmpty) {
        state = state.copyWith(step: CsvImportStep.idle);
        return;
      }

      final file = result.files.first;
      String content = String.fromCharCodes(file.bytes!);

      // Detectar encoding Latin-1 vs UTF-8
      if (content.contains('\uFFFD')) {
        // Fallback a latin1
        content = String.fromCharCodes(file.bytes!.map((b) => b & 0xFF));
      }

      // Detección automática: intentar cada parser en orden
      final parsers = <BaseCsvParser>[BnCsvParser(), BacCsvParser()];
      BaseCsvParser? parser;
      for (final p in parsers) {
        if (p.canParse(content)) {
          parser = p;
          break;
        }
      }

      if (parser == null) {
        state = state.copyWith(
          step: CsvImportStep.error,
          errorMessage:
              'Formato no reconocido. Soportados: Banco Nacional y BAC San José.',
        );
        return;
      }

      final parseResult = parser.parse(content);
      if (parseResult.isEmpty) {
        state = state.copyWith(
          step: CsvImportStep.error,
          errorMessage: 'El archivo no contiene transacciones válidas.',
        );
        return;
      }

      // Por defecto, todas las filas seleccionadas
      final allRows = Set<int>.from(
        List.generate(parseResult.transactions.length, (i) => i),
      );
      state = state.copyWith(
        step: CsvImportStep.preview,
        parseResult: parseResult,
        selectedRows: allRows,
      );
    } catch (e) {
      state = state.copyWith(
        step: CsvImportStep.error,
        errorMessage: 'Error al leer el archivo: $e',
      );
    }
  }

  // 2. Marcar/desmarcar una fila individual
  void toggleRow(int index) {
    final updated = Set<int>.from(state.selectedRows);
    if (updated.contains(index)) {
      updated.remove(index);
    } else {
      updated.add(index);
    }
    state = state.copyWith(selectedRows: updated);
  }

  // 3. Seleccionar / deseleccionar todas
  void toggleAll() {
    final total = state.parseResult?.transactions.length ?? 0;
    if (state.selectedRows.length == total) {
      state = state.copyWith(selectedRows: {});
    } else {
      state = state.copyWith(
        selectedRows: Set.from(List.generate(total, (i) => i)),
      );
    }
  }

  // 4. Importar las filas seleccionadas
  Future<void> importSelected() async {
    final pr = state.parseResult;
    if (pr == null || state.selectedRows.isEmpty) return;

    state = state.copyWith(step: CsvImportStep.importing);
    final repo = _ref.read(transactionRepositoryProvider);
    const uuid = Uuid();
    int count = 0;

    for (final idx in state.selectedRows) {
      final csv = pr.transactions[idx];
      final tx = Transaction(
        id: uuid.v4(),
        familyId: familyId,
        envelopeId: envelopeId,
        registeredBy: registeredBy,
        amount: csv.absoluteAmount,
        description: csv.description,
        transactionDate: csv.date,
        transactionType:
            csv.isExpense ? TransactionType.expense : TransactionType.income,
        status: TransactionStatus.confirmed,
        source: TransactionSource.csvImport,
      );
      await repo.saveTransaction(tx);
      count++;
    }

    state = state.copyWith(step: CsvImportStep.done, importedCount: count);
  }

  void reset() => state = const CsvImportState();
}

// ── Provider ──────────────────────────────────────────────────────────────────

/// Parámetro tipado para el provider de importación CSV.
typedef CsvImportParams = ({
  String familyId,
  String envelopeId,
  String registeredBy,
});

final csvImportProvider = StateNotifierProvider.autoDispose
    .family<CsvImportNotifier, CsvImportState, CsvImportParams>(
  (ref, params) => CsvImportNotifier(
    ref: ref,
    familyId: params.familyId,
    envelopeId: params.envelopeId,
    registeredBy: params.registeredBy,
  ),
);
