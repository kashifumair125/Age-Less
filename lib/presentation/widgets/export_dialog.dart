// lib/presentation/widgets/export_dialog.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/services/export_service.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/assessment_repository.dart';
import '../../data/repositories/tracking_repository.dart';

class ExportDialog extends ConsumerWidget {
  const ExportDialog({Key? key}) : super(key: key);

  Future<void> _exportData(
    BuildContext context,
    WidgetRef ref,
    String format,
  ) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final userRepo = ref.read(userRepositoryProvider);
      final assessmentRepo = ref.read(assessmentRepositoryProvider);
      final trackingRepo = ref.read(trackingRepositoryProvider);

      final profile = await userRepo.getUserProfile();
      final assessments = await assessmentRepo.getAssessments();
      final tracking = await trackingRepo.getAllTracking();

      final exportService = ExportService();
      String exportData;
      String filename;
      String mimeType;

      switch (format) {
        case 'json':
          exportData = exportService.exportAsJson(
            profile: profile,
            trackingHistory: tracking,
            assessments: assessments,
          );
          filename = 'ageless_export_${DateTime.now().toIso8601String().split('T')[0]}.json';
          mimeType = 'application/json';
          break;
        case 'csv_tracking':
          exportData = exportService.exportAsCSV(tracking);
          filename = 'ageless_tracking_${DateTime.now().toIso8601String().split('T')[0]}.csv';
          mimeType = 'text/csv';
          break;
        case 'csv_assessments':
          exportData = exportService.exportAssessmentsAsCSV(assessments);
          filename = 'ageless_assessments_${DateTime.now().toIso8601String().split('T')[0]}.csv';
          mimeType = 'text/csv';
          break;
        default:
          throw Exception('Unknown export format');
      }

      // Save to temporary file
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/$filename';
      final file = File(filePath);
      await file.writeAsString(exportData);

      // Also copy to clipboard as backup
      await Clipboard.setData(ClipboardData(text: exportData));

      if (!context.mounted) return;

      // Close loading dialog
      Navigator.of(context).pop();

      // Share the file
      final result = await Share.shareXFiles(
        [XFile(filePath, mimeType: mimeType)],
        subject: 'AgeLess Health Data Export',
        text: 'Your AgeLess health data export: $filename',
      );

      if (!context.mounted) return;

      // Show success message
      if (result.status == ShareResultStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Export successful! File shared.'),
            backgroundColor: AppTheme.successColor,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        // If sharing was dismissed, still show success with clipboard info
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Export completed!'),
                const SizedBox(height: 4),
                Text(
                  'Data copied to clipboard as backup.',
                  style: AppTextStyles.caption.copyWith(color: Colors.white70),
                ),
              ],
            ),
            backgroundColor: AppTheme.successColor,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;

      // Close loading dialog if still open
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export failed: $e'),
          backgroundColor: AppTheme.errorColor,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Export Health Data'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Choose export format:',
            style: AppTextStyles.body1,
          ),
          const SizedBox(height: AppSpacing.lg),
          _ExportOptionTile(
            icon: Icons.code,
            title: 'JSON (Complete)',
            subtitle: 'All data including profile, tracking, and assessments',
            onTap: () {
              Navigator.of(context).pop();
              _exportData(context, ref, 'json');
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          _ExportOptionTile(
            icon: Icons.table_chart,
            title: 'CSV (Tracking)',
            subtitle: 'Daily tracking data in spreadsheet format',
            onTap: () {
              Navigator.of(context).pop();
              _exportData(context, ref, 'csv_tracking');
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          _ExportOptionTile(
            icon: Icons.assessment,
            title: 'CSV (Assessments)',
            subtitle: 'Assessment history with category scores',
            onTap: () {
              Navigator.of(context).pop();
              _exportData(context, ref, 'csv_assessments');
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

class _ExportOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ExportOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppBorderRadius.medium,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: AppBorderRadius.medium,
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 32),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body1.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
