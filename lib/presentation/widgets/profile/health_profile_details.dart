import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/health_profile.dart';

class HealthProfileDetails extends StatelessWidget {
  final HealthProfile? healthProfile;
  final VoidCallback onEdit;

  const HealthProfileDetails({
    Key? key,
    this.healthProfile,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: AppBorderRadius.large,
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.medical_information, color: AppTheme.errorColor),
                  const SizedBox(width: AppSpacing.sm),
                  Text('Health Profile', style: AppTextStyles.h3),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
                color: AppTheme.primaryColor,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (healthProfile == null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    Icon(Icons.medical_information_outlined, size: 48, color: Colors.grey.shade300),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'No health profile yet',
                      style: AppTextStyles.body2.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ElevatedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Health Info'),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            _HealthSection(
              title: 'Medical History',
              icon: Icons.history,
              items: healthProfile!.medicalHistory.isEmpty
                  ? ['No conditions recorded']
                  : healthProfile!.medicalHistory.map((c) => c.name).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),
            _HealthSection(
              title: 'Current Medications',
              icon: Icons.medication,
              items: healthProfile!.currentMedications.isEmpty
                  ? ['No medications recorded']
                  : healthProfile!.currentMedications.map((m) => '${m.name} - ${m.dosage}').toList(),
            ),
            const SizedBox(height: AppSpacing.lg),
            _HealthSection(
              title: 'Allergies',
              icon: Icons.warning_amber,
              items: healthProfile!.allergies.isEmpty
                  ? ['No allergies recorded']
                  : healthProfile!.allergies,
            ),
            if (healthProfile!.doctorNotes != null && healthProfile!.doctorNotes!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              const Divider(),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Doctor Notes',
                style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: AppBorderRadius.small,
                ),
                child: Text(
                  healthProfile!.doctorNotes!,
                  style: AppTextStyles.body2,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _HealthSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> items;

  const _HealthSection({
    required this.title,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.primaryColor),
            const SizedBox(width: AppSpacing.sm),
            Text(
              title,
              style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ...items.take(3).map((item) => Padding(
              padding: const EdgeInsets.only(left: AppSpacing.lg, bottom: AppSpacing.xs),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 6, color: Colors.grey),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      item,
                      style: AppTextStyles.body2.copyWith(color: Colors.grey.shade700),
                    ),
                  ),
                ],
              ),
            )),
        if (items.length > 3)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.lg),
            child: Text(
              '+${items.length - 3} more',
              style: AppTextStyles.caption.copyWith(color: AppTheme.primaryColor),
            ),
          ),
      ],
    );
  }
}
