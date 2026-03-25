import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:kakeibo_pro/core/constants/app_colors.dart';
import 'package:kakeibo_pro/features/email/domain/models/bank_email.dart';
import 'package:kakeibo_pro/features/email/presentation/providers/gmail_provider.dart';

class EmailTransactionsPage extends ConsumerWidget {
  const EmailTransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gmailProvider);
    final notifier = ref.read(gmailProvider.notifier);

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
          'Correos bancarios',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textMuted),
            onPressed: state.isLoading ? null : notifier.fetchEmails,
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (state.isLoading) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Leyendo correos bancarios…',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                ],
              ),
            );
          }

          if (state.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppColors.error, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      state.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.error),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: notifier.fetchEmails,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.emails.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inbox_outlined,
                      size: 64, color: AppColors.textMuted),
                  SizedBox(height: 16),
                  Text(
                    'No se encontraron correos bancarios',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Se buscan correos de BN, BAC, Davivienda y Scotiabank\nde los últimos 90 días.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            );
          }

          final parsed = state.emails.where((e) => e.isParsed).toList();
          final unparsed = state.emails.where((e) => !e.isParsed).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (parsed.isNotEmpty) ...[
                _SectionHeader(
                    title: 'Transacciones detectadas (${parsed.length})'),
                const SizedBox(height: 8),
                ...parsed.map((e) => _EmailCard(email: e, parsed: true)),
              ],
              if (unparsed.isNotEmpty) ...[
                const SizedBox(height: 16),
                _SectionHeader(
                    title: 'No procesados (${unparsed.length})'),
                const SizedBox(height: 8),
                ...unparsed.map((e) => _EmailCard(email: e, parsed: false)),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textMuted,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _EmailCard extends StatelessWidget {
  final BankEmail email;
  final bool parsed;

  const _EmailCard({required this.email, required this.parsed});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM yyyy', 'es');

    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: parsed
              ? AppColors.green.withValues(alpha: 0.2)
              : AppColors.border,
        ),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: parsed
              ? AppColors.green.withValues(alpha: 0.1)
              : AppColors.surfaceVariant,
          child: Icon(
            parsed ? Icons.receipt_outlined : Icons.mail_outline,
            color: parsed ? AppColors.green : AppColors.textMuted,
            size: 20,
          ),
        ),
        title: Text(
          email.merchant ?? email.subject,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (email.description != null)
              Text(
                email.description!,
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            Text(
              fmt.format(email.date),
              style: const TextStyle(
                  color: AppColors.textMuted, fontSize: 11),
            ),
          ],
        ),
        trailing: email.amount != null
            ? Text(
                '₡${email.amount!.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              )
            : const Icon(Icons.help_outline,
                color: AppColors.textMuted, size: 18),
      ),
    );
  }
}
