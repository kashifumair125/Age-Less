import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class DataPrivacySection extends StatelessWidget {
  final VoidCallback onExportData;
  final VoidCallback onDeleteAccount;
  final VoidCallback onPrivacySettings;
  final VoidCallback onBackupData;

  const DataPrivacySection({
    Key? key,
    required this.onExportData,
    required this.onDeleteAccount,
    required this.onPrivacySettings,
    required this.onBackupData,
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
            children: [
              Icon(Icons.security, color: AppTheme.primaryColor),
              const SizedBox(width: AppSpacing.sm),
              Text('Data & Privacy', style: AppTextStyles.h3),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _PrivacyItem(
            icon: Icons.download,
            label: 'Export Data',
            subtitle: 'Download all your health data',
            onTap: onExportData,
            color: AppTheme.primaryColor,
          ),
          const Divider(height: AppSpacing.lg),
          _PrivacyItem(
            icon: Icons.backup,
            label: 'Backup & Restore',
            subtitle: 'Backup your data to cloud',
            onTap: onBackupData,
            color: AppTheme.secondaryColor,
          ),
          const Divider(height: AppSpacing.lg),
          _PrivacyItem(
            icon: Icons.privacy_tip,
            label: 'Privacy Controls',
            subtitle: 'Manage data sharing preferences',
            onTap: onPrivacySettings,
            color: AppTheme.warningColor,
          ),
          const Divider(height: AppSpacing.lg),
          _PrivacyItem(
            icon: Icons.delete_forever,
            label: 'Delete Account',
            subtitle: 'Permanently delete all data',
            onTap: () => _showDeleteAccountDialog(context),
            color: AppTheme.errorColor,
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: AppTheme.errorColor),
            SizedBox(width: AppSpacing.sm),
            Text('Delete Account'),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDeleteAccount();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _PrivacyItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final Color color;

  const _PrivacyItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppBorderRadius.medium,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
