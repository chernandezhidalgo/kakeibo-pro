import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakeibo_pro/core/constants/app_colors.dart';
import 'package:kakeibo_pro/features/auth/domain/entities/family_member.dart';
import 'package:kakeibo_pro/features/auth/presentation/providers/family_provider.dart';

/// Pantalla de invitación de nuevos miembros a la familia.
/// Accesible solo para Admin y Co-Admin.
class InviteMemberPage extends ConsumerStatefulWidget {
  const InviteMemberPage({super.key});

  @override
  ConsumerState<InviteMemberPage> createState() => _InviteMemberPageState();
}

class _InviteMemberPageState extends ConsumerState<InviteMemberPage> {
  FamilyMemberRole _selectedRole = FamilyMemberRole.coAdmin;
  bool _isLoading = false;
  String? _generatedToken;
  final _tokenController = TextEditingController();

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _generateInvitation() async {
    final familyAsync = ref.read(currentFamilyProvider);
    final family = familyAsync.valueOrNull;
    if (family == null) return;

    setState(() {
      _isLoading = true;
      _generatedToken = null;
    });

    final result = await ref
        .read(generateInvitationUseCaseProvider)
        .call(family.id, _selectedRole);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.failure != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.failure!.message),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final token = result.data!;
    setState(() {
      _generatedToken = token;
      _tokenController.text = token;
    });
  }

  Future<void> _copyLink() async {
    if (_generatedToken == null) return;

    await Clipboard.setData(
      ClipboardData(text: 'Únete a KakeiboPro con este código: $_generatedToken'),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Link copiado al portapapeles!'),
        backgroundColor: AppColors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Verificar que el usuario tenga permisos de Admin o Co-Admin
    final role = ref.watch(currentMemberRoleProvider);
    final hasPermission =
        role == FamilyMemberRole.admin || role == FamilyMemberRole.coAdmin;

    if (!hasPermission) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Invitar miembro')),
        body: const Center(
          child: Text(
            'Solo los administradores pueden invitar miembros.',
            style: TextStyle(color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Invitar miembro'),
        backgroundColor: AppColors.surface,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Encabezado ──
              const Text(
                '👥',
                style: TextStyle(fontSize: 64),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Invitar a un miembro',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Selecciona el rol y genera un código de invitación válido por 48 horas.',
                style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // ── Selector de rol ──
              const Text(
                'Rol del nuevo miembro',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 12),
              _RoleSelector(
                selected: _selectedRole,
                onChanged: (role) => setState(() => _selectedRole = role),
              ),
              const SizedBox(height: 32),

              // ── Botón generar ──
              ElevatedButton(
                onPressed: _isLoading ? null : _generateInvitation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Generar invitación',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),

              // ── Token generado ──
              if (_generatedToken != null) ...[
                const SizedBox(height: 32),
                const Text(
                  'Código de invitación',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _tokenController,
                  readOnly: true,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontFamily: 'monospace',
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.green),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.copy, color: AppColors.textMuted),
                      onPressed: _copyLink,
                      tooltip: 'Copiar código',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _copyLink,
                  icon: const Icon(Icons.link, color: AppColors.green),
                  label: const Text(
                    'Copiar link',
                    style: TextStyle(
                      color: AppColors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    side: const BorderSide(color: AppColors.green),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '⏱ Este código expira en 48 horas.',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Widget auxiliar: selector de rol ──────────────────────────────────────────

class _RoleSelector extends StatelessWidget {
  const _RoleSelector({
    required this.selected,
    required this.onChanged,
  });

  final FamilyMemberRole selected;
  final ValueChanged<FamilyMemberRole> onChanged;

  @override
  Widget build(BuildContext context) {
    const options = [
      (role: FamilyMemberRole.coAdmin, label: 'Co-Admin', icon: Icons.admin_panel_settings_outlined),
      (role: FamilyMemberRole.adolescent, label: 'Adolescente', icon: Icons.school_outlined),
    ];

    return Row(
      children: options.map((opt) {
        final isSelected = selected == opt.role;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(opt.role),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.blue.withOpacity(0.15) : AppColors.surface,
                border: Border.all(
                  color: isSelected ? AppColors.blue : AppColors.border,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    opt.icon,
                    color: isSelected ? AppColors.blue : AppColors.textMuted,
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    opt.label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textMuted,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
