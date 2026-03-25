import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kakeibo_pro/core/constants/app_colors.dart';
import 'package:kakeibo_pro/core/utils/currency_formatter.dart';
import 'package:kakeibo_pro/features/csv/presentation/providers/csv_import_provider.dart';

class CsvImportPage extends ConsumerWidget {
  final String envelopeId;
  final String envelopeName;
  final String familyId;
  final String registeredBy;

  const CsvImportPage({
    super.key,
    required this.envelopeId,
    required this.envelopeName,
    required this.familyId,
    required this.registeredBy,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = (
      familyId: familyId,
      envelopeId: envelopeId,
      registeredBy: registeredBy,
    );
    final state = ref.watch(csvImportProvider(params));
    final notifier = ref.read(csvImportProvider(params).notifier);

    // Regresar automáticamente al terminar
    ref.listen(csvImportProvider(params), (_, next) {
      if (next.step == CsvImportStep.done) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${next.importedCount} movimientos importados'),
          backgroundColor: AppColors.green,
        ));
        Navigator.of(context).pop();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textMuted),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Importar CSV — $envelopeName',
          style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w600),
        ),
        actions: [
          if (state.step == CsvImportStep.preview)
            TextButton(
              onPressed:
                  state.selectedRows.isEmpty ? null : notifier.importSelected,
              child: Text(
                'Importar (${state.selectedRows.length})',
                style: TextStyle(
                  color: state.selectedRows.isEmpty
                      ? AppColors.textMuted
                      : AppColors.green,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(context, state, notifier),
    );
  }

  Widget _buildBody(
      BuildContext context, CsvImportState state, CsvImportNotifier notifier) {
    return switch (state.step) {
      CsvImportStep.idle => _IdleView(onPick: notifier.pickAndParse),
      CsvImportStep.parsing =>
        const _LoadingView(label: 'Leyendo archivo...'),
      CsvImportStep.importing =>
        const _LoadingView(label: 'Importando movimientos...'),
      CsvImportStep.preview =>
        _PreviewView(state: state, notifier: notifier),
      CsvImportStep.error => _ErrorView(
          message: state.errorMessage ?? 'Error desconocido',
          onRetry: notifier.pickAndParse,
        ),
      CsvImportStep.done => const _LoadingView(label: '¡Listo!'),
    };
  }
}

// ── Vista inicial (seleccionar archivo) ───────────────────────────────────────

class _IdleView extends StatelessWidget {
  final VoidCallback onPick;
  const _IdleView({required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.upload_file_outlined,
                  color: AppColors.green, size: 40),
            ),
            const SizedBox(height: 24),
            const Text(
              'Importar CSV bancario',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Seleccioná el archivo CSV exportado\ndesde tu banco (BN o BAC).',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.textMuted, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onPick,
                icon: const Icon(Icons.folder_open_outlined),
                label: const Text('Seleccionar archivo',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Vista de carga ────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  final String label;
  const _LoadingView({required this.label});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
                color: AppColors.green, strokeWidth: 2),
            const SizedBox(height: 16),
            Text(label,
                style: const TextStyle(color: AppColors.textMuted)),
          ],
        ),
      );
}

// ── Vista de error ────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline,
                  color: AppColors.error, size: 48),
              const SizedBox(height: 16),
              Text(message,
                  style: const TextStyle(
                      color: AppColors.error, fontSize: 13),
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.upload_file_outlined,
                    color: AppColors.green),
                label: const Text('Intentar de nuevo',
                    style: TextStyle(color: AppColors.green)),
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.green)),
              ),
            ],
          ),
        ),
      );
}

// ── Vista de previsualización ─────────────────────────────────────────────────

class _PreviewView extends StatelessWidget {
  final CsvImportState state;
  final CsvImportNotifier notifier;
  const _PreviewView({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final pr = state.parseResult!;
    final fmt = DateFormat('d MMM', 'es');

    return Column(
      children: [
        // Encabezado con resumen
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${pr.transactions.length} movimientos · ${pr.bankName}',
                style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: notifier.toggleAll,
                child: Text(
                  state.selectedRows.length == pr.transactions.length
                      ? 'Ninguno'
                      : 'Todos',
                  style: const TextStyle(
                      color: AppColors.blue, fontSize: 13),
                ),
              ),
            ],
          ),
        ),

        // Lista de filas
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: pr.transactions.length,
            itemBuilder: (_, i) {
              final tx = pr.transactions[i];
              final selected = state.selectedRows.contains(i);
              final color =
                  tx.isExpense ? AppColors.error : AppColors.green;
              return CheckboxListTile(
                value: selected,
                onChanged: (_) => notifier.toggleRow(i),
                activeColor: AppColors.green,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                title: Text(
                  tx.description,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  fmt.format(tx.date),
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 12),
                ),
                secondary: Text(
                  '${tx.isExpense ? "-" : "+"}${CurrencyFormatter.format(tx.absoluteAmount)}',
                  style: TextStyle(
                      color: color,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
              );
            },
          ),
        ),

        // Botón importar
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.selectedRows.isEmpty
                  ? null
                  : notifier.importSelected,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.black,
                disabledBackgroundColor: AppColors.border,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                'Importar ${state.selectedRows.length} movimientos',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
