import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:kakeibo_pro/core/constants/app_colors.dart';
import 'package:kakeibo_pro/features/ocr/presentation/providers/ocr_provider.dart';

class OcrCapturePage extends ConsumerStatefulWidget {
  final String envelopeId;
  final String familyId;

  const OcrCapturePage({
    super.key,
    required this.envelopeId,
    required this.familyId,
  });

  @override
  ConsumerState<OcrCapturePage> createState() => _OcrCapturePageState();
}

class _OcrCapturePageState extends ConsumerState<OcrCapturePage> {
  final _picker = ImagePicker();
  String? _imagePath;

  @override
  Widget build(BuildContext context) {
    final ocrState = ref.watch(ocrProvider);
    final notifier = ref.read(ocrProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textMuted, size: 18),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Escanear recibo',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Botones de captura ────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _SourceButton(
                    icon: Icons.camera_alt_outlined,
                    label: 'Cámara',
                    onTap: () => _pick(ImageSource.camera, notifier),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SourceButton(
                    icon: Icons.photo_library_outlined,
                    label: 'Galería',
                    onTap: () => _pick(ImageSource.gallery, notifier),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Resultado ─────────────────────────────────────────────────
            Expanded(
              child: switch (ocrState) {
                OcrIdle _ => _imagePath == null
                    ? const _EmptyState()
                    : const SizedBox.shrink(),
                OcrLoading l => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          l.message,
                          style: const TextStyle(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                OcrSuccess s => _ResultCard(
                    result: s,
                    onUse: () {
                      // Navegar a agregar-movimiento con los datos pre-llenados
                      context.pop(); // Regresa al detalle del sobre
                    },
                    onReset: notifier.reset,
                  ),
                OcrError e => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline,
                            color: AppColors.error, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          e.message,
                          style: const TextStyle(color: AppColors.error),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: notifier.reset,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pick(ImageSource source, OcrNotifier notifier) async {
    final file = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1920,
    );
    if (file == null) return;
    setState(() => _imagePath = file.path);
    await notifier.processImage(file.path);
  }
}

// ── Widgets auxiliares ─────────────────────────────────────────────────────────

class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SourceButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.blue, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 64, color: AppColors.textMuted),
          SizedBox(height: 16),
          Text(
            'Toma o sube una foto de tu recibo',
            style: TextStyle(color: AppColors.textMuted),
          ),
          SizedBox(height: 8),
          Text(
            'KakeiboPro extraerá el monto y comercio automáticamente.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final OcrSuccess result;
  final VoidCallback onUse;
  final VoidCallback onReset;

  const _ResultCard({
    required this.result,
    required this.onUse,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final r = result.result;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: r.isProcessed
                  ? AppColors.green.withValues(alpha: 0.3)
                  : AppColors.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    r.isProcessed
                        ? Icons.check_circle_outline
                        : Icons.warning_amber_outlined,
                    color: r.isProcessed ? AppColors.green : AppColors.gold,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    r.isProcessed ? 'Recibo procesado' : 'Procesamiento parcial',
                    style: TextStyle(
                      color:
                          r.isProcessed ? AppColors.green : AppColors.gold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (r.merchant != null)
                _DataRow(label: 'Comercio', value: r.merchant!),
              if (r.amount != null)
                _DataRow(
                    label: 'Monto',
                    value: '₡${r.amount!.toStringAsFixed(0)}'),
              if (r.description != null)
                _DataRow(label: 'Descripción', value: r.description!),
              const SizedBox(height: 12),
              const Text(
                'Texto reconocido:',
                style:
                    TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
              const SizedBox(height: 4),
              Text(
                r.rawText.length > 200
                    ? '${r.rawText.substring(0, 200)}…'
                    : r.rawText,
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 11),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onUse,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text(
            'Usar estos datos',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: onReset,
          child: const Text(
            'Escanear otro recibo',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      ],
    );
  }
}

class _DataRow extends StatelessWidget {
  final String label;
  final String value;
  const _DataRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                  color: AppColors.textMuted, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
