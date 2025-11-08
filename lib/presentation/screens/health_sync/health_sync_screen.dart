// lib/presentation/screens/health_sync/health_sync_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/services/health_sync_service.dart';
import 'dart:io' show Platform;

class HealthSyncScreen extends ConsumerStatefulWidget {
  const HealthSyncScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HealthSyncScreen> createState() => _HealthSyncScreenState();
}

class _HealthSyncScreenState extends ConsumerState<HealthSyncScreen> {
  final _healthSyncService = HealthSyncService();
  bool _isAuthorized = false;
  bool _isLoading = false;
  bool _isSyncing = false;
  List<HealthDataSummary> _syncedData = [];

  @override
  void initState() {
    super.initState();
    _checkAuthorization();
  }

  Future<void> _checkAuthorization() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authorized = await _healthSyncService.isAuthorized();
      setState(() {
        _isAuthorized = authorized;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _requestPermissions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final granted = await _healthSyncService.requestPermissions();
      setState(() {
        _isAuthorized = granted;
        _isLoading = false;
      });

      if (granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Health data access granted!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Health data access denied'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error requesting permissions: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  Future<void> _syncHealthData() async {
    if (!_isAuthorized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please grant health data access first'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }

    setState(() {
      _isSyncing = true;
    });

    try {
      final data = await _healthSyncService.syncLastDays(7);
      setState(() {
        _syncedData = data;
        _isSyncing = false;
      });

      if (data.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Synced ${data.length} days of health data!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No health data found'),
            backgroundColor: AppTheme.warningColor,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSyncing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error syncing data: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  String get _platformName {
    if (Platform.isIOS) return 'Apple Health';
    if (Platform.isAndroid) return 'Google Fit';
    return 'Health App';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wearable Sync'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.1),
                  AppTheme.secondaryColor.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppBorderRadius.large,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Platform.isIOS ? Icons.watch : Icons.watch,
                      size: 32,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'Connect to $_platformName',
                        style: AppTextStyles.h3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Automatically sync your health data from your wearable device or phone.',
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Connection Status
          _buildStatusCard(),

          const SizedBox(height: AppSpacing.lg),

          // Connect/Sync Buttons
          if (!_isAuthorized)
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _requestPermissions,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.link),
              label: Text(_isLoading ? 'Connecting...' : 'Connect to $_platformName'),
            )
          else
            ElevatedButton.icon(
              onPressed: _isSyncing ? null : _syncHealthData,
              icon: _isSyncing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.sync),
              label: Text(_isSyncing ? 'Syncing...' : 'Sync Last 7 Days'),
            ),

          const SizedBox(height: AppSpacing.xl),

          // Synced Data Summary
          if (_syncedData.isNotEmpty) ...[
            Text('Synced Data', style: AppTextStyles.h3),
            const SizedBox(height: AppSpacing.md),
            ..._syncedData.map((summary) => _buildDataSummaryCard(summary)).toList(),
          ],

          // Information
          const SizedBox(height: AppSpacing.xl),
          _buildInfoCard(),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: _isAuthorized ? AppTheme.successColor.withOpacity(0.1) : Colors.grey.shade100,
        borderRadius: AppBorderRadius.large,
        border: Border.all(
          color: _isAuthorized ? AppTheme.successColor : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isAuthorized ? Icons.check_circle : Icons.info_outline,
            color: _isAuthorized ? AppTheme.successColor : Colors.grey.shade600,
            size: 32,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isAuthorized ? 'Connected' : 'Not Connected',
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _isAuthorized ? AppTheme.successColor : Colors.grey.shade600,
                  ),
                ),
                Text(
                  _isAuthorized
                      ? 'Your $_platformName is connected'
                      : 'Connect to sync health data',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataSummaryCard(HealthDataSummary summary) {
    final date = '${summary.date.year}-${summary.date.month.toString().padLeft(2, '0')}-${summary.date.day.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppBorderRadius.medium,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetric(Icons.directions_walk, '${summary.steps}', 'steps'),
              _buildMetric(Icons.local_fire_department, '${summary.activeCalories}', 'kcal'),
              _buildMetric(Icons.fitness_center, '${summary.workoutMinutes}', 'min'),
              _buildMetric(Icons.bedtime, summary.sleepHours.toStringAsFixed(1), 'hrs'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 20),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: AppBorderRadius.large,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: Colors.blue.shade700),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'About Health Sync',
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '• Syncing is optional and requires permission\n'
            '• We only read data, never write to your health apps\n'
            '• All data stays on your device (offline-first)\n'
            '• Supported: steps, workouts, sleep, and calories',
            style: AppTextStyles.body2.copyWith(color: Colors.blue.shade900),
          ),
        ],
      ),
    );
  }
}
