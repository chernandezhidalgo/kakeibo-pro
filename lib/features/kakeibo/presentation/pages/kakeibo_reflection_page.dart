import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kakeibo_pro/core/constants/app_colors.dart';
import 'package:kakeibo_pro/features/kakeibo/presentation/providers/reflection_provider.dart';

class KakeiboReflectionPage extends ConsumerStatefulWidget {
  final String familyId;
  final double incomeTotal;
  final double expenseTotal;

  const KakeiboReflectionPage({
    super.key,
    required this.familyId,
    required this.incomeTotal,
    required this.expenseTotal,
  });

  @override
  ConsumerState<KakeiboReflectionPage> createState() =>
      _KakeiboReflectionPageState();
}

class _KakeiboReflectionPageState
    extends ConsumerState<KakeiboReflectionPage> {
  final _q1 = TextEditingController();
  final _q2 = TextEditingController();
  final _q3 = TextEditingController();
  final _q4 = TextEditingController();
  final _savings = TextEditingController();
  late final ReflectionParams _params;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _params = (familyId: widget.familyId, year: now.year, month: now.month);
  }

  @override
  void dispose() {
    _q1.dispose();
    _q2.dispose();
    _q3.dispose();
    _q4.dispose();
    _savings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reflectionProvider(_params));
    final notifier = ref.read(reflectionProvider(_params).notifier);
    final now = DateTime.now();
    final monthName = DateFormat('MMMM yyyy', 'es').format(now);

    ref.listen(reflectionProvider(_params), (_, next) {
      if (next.savedOk) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reflexión guardada'),
            backgroundColor: AppColors.green,
          ),
        );
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
          'Reflexión — $monthName',
          style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intro del método Kakeibo
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.green.withValues(alpha: 0.3)),
              ),
              child: const Text(
                'El método Kakeibo invita a reflexionar cada mes con 4 preguntas. '
                'Respondelas con honestidad — no hay respuestas correctas.',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    height: 1.5),
              ),
            ),
            const SizedBox(height: 32),

            // 4 preguntas
            _QuestionField(
              number: 1,
              question: '¿Cuánto dinero tenés disponible este mes?',
              hint: 'Describí tus ingresos esperados...',
              controller: _q1,
              onChanged: notifier.setQ1,
            ),
            const SizedBox(height: 24),
            _QuestionField(
              number: 2,
              question: '¿Cuánto dinero querés gastar?',
              hint: '¿Qué gastos son necesarios este mes?',
              controller: _q2,
              onChanged: notifier.setQ2,
            ),
            const SizedBox(height: 24),
            _QuestionField(
              number: 3,
              question: '¿Cuánto dinero querés ahorrar?',
              hint: 'Definí tu objetivo de ahorro...',
              controller: _q3,
              onChanged: notifier.setQ3,
            ),
            const SizedBox(height: 12),

            // Campo numérico de objetivo de ahorro (₡)
            TextField(
              controller: _savings,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: const TextStyle(
                    color: AppColors.textMuted, fontSize: 20),
                prefixText: 'Objetivo: ₡ ',
                prefixStyle: const TextStyle(
                    color: AppColors.textMuted, fontSize: 16),
                filled: true,
                fillColor: AppColors.surfaceVariant,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.border)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColors.green, width: 1.5)),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: notifier.setSavingsTarget,
            ),
            const SizedBox(height: 24),
            _QuestionField(
              number: 4,
              question: '¿Cómo podés mejorar?',
              hint: '¿Qué hábito vas a cambiar el próximo mes?',
              controller: _q4,
              onChanged: notifier.setQ4,
              minLines: 3,
            ),
            const SizedBox(height: 40),

            // Mensaje de error
            if (state.errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.3)),
                ),
                child: Text(state.errorMessage!,
                    style: const TextStyle(
                        color: AppColors.error, fontSize: 13)),
              ),
              const SizedBox(height: 16),
            ],

            // Botón guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.canSave && !state.isLoading
                    ? () => notifier.save(
                          incomeTotal: widget.incomeTotal,
                          expenseTotal: widget.expenseTotal,
                        )
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: AppColors.border,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: state.isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.black, strokeWidth: 2.5))
                    : const Text('Guardar reflexión',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ── Widget de pregunta ────────────────────────────────────────────────────────

class _QuestionField extends StatelessWidget {
  final int number;
  final String question;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final int minLines;

  const _QuestionField({
    required this.number,
    required this.question,
    required this.hint,
    required this.controller,
    required this.onChanged,
    this.minLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                  color: AppColors.green, shape: BoxShape.circle),
              child: Center(
                child: Text(
                  '$number',
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                question,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          style: const TextStyle(
              color: AppColors.textPrimary, fontSize: 14, height: 1.5),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.surfaceVariant,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.green, width: 1.5)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          onChanged: onChanged,
          textCapitalization: TextCapitalization.sentences,
          minLines: minLines,
          maxLines: 6,
        ),
      ],
    );
  }
}
