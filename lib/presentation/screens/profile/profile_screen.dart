// lib/presentation/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../domain/models/user_profile.dart';
import 'profile_edit_screen.dart';
import '../../widgets/export_dialog.dart';
import '../health_sync/health_sync_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRepository = ref.read(userRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfileEditScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<UserProfile?>(
        future: userRepository.getUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = snapshot.data;
          if (profile == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_off, size: 64, color: Colors.grey),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'No profile found',
                    style: AppTextStyles.body1.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Calculate age from birthDate
          final age = profile.birthDate != null
              ? DateTime.now().year - profile.birthDate!.year
              : null;

          // Get initials for avatar
          final initials = profile.name.isNotEmpty
              ? profile.name.split(' ').map((n) => n[0]).take(2).join()
              : 'U';

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              // Profile Header
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.primaryColor,
                      child: Text(
                        initials.toUpperCase(),
                        style: const TextStyle(fontSize: 40, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(profile.name, style: AppTextStyles.h2),
                    if (age != null)
                      Text(
                        '$age years old',
                        style: AppTextStyles.body2.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    if (profile.email.isNotEmpty)
                      Text(
                        profile.email,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.grey.shade500,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              _ProfileSection(
                title: 'Health Data',
                items: [
                  _ProfileItem(
                    icon: Icons.cake,
                    label: 'Date of Birth',
                    value: profile.birthDate != null
                        ? '${profile.birthDate!.year}-${profile.birthDate!.month.toString().padLeft(2, '0')}-${profile.birthDate!.day.toString().padLeft(2, '0')}'
                        : 'Not set',
                  ),
                  _ProfileItem(
                    icon: Icons.height,
                    label: 'Height',
                    value: '${profile.heightCm.toStringAsFixed(0)} cm',
                  ),
                  _ProfileItem(
                    icon: Icons.monitor_weight,
                    label: 'Weight',
                    value: '${profile.weightKg.toStringAsFixed(1)} kg',
                  ),
                  if (profile.gender != null)
                    _ProfileItem(
                      icon: Icons.person,
                      label: 'Gender',
                      value: profile.gender!,
                    ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              _ProfileSection(
                title: 'Preferences',
                items: [
                  _ProfileItem(
                    icon: Icons.notifications,
                    label: 'Notifications',
                    trailing: Switch(value: true, onChanged: (v) {}),
                  ),
                  _ProfileItem(
                    icon: Icons.dark_mode,
                    label: 'Dark Mode',
                    trailing: Switch(value: false, onChanged: (v) {}),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              _ProfileSection(
                title: 'Data',
                items: [
                  _ProfileItem(
                    icon: Icons.watch,
                    label: 'Sync Wearables',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const HealthSyncScreen(),
                        ),
                      );
                    },
                  ),
                  _ProfileItem(
                    icon: Icons.file_download,
                    label: 'Export Data',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const ExportDialog(),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              _ProfileSection(
                title: 'About',
                items: [
                  _ProfileItem(
                    icon: Icons.info,
                    label: 'About AgeLess',
                    onTap: () {},
                  ),
                  _ProfileItem(
                    icon: Icons.privacy_tip,
                    label: 'Privacy Policy',
                    onTap: () {},
                  ),
                  _ProfileItem(
                    icon: Icons.description,
                    label: 'Terms of Service',
                    onTap: () {},
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _ProfileSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.sm),
          child: Text(title, style: AppTextStyles.h3),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: AppBorderRadius.large,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _ProfileItem({
    required this.icon,
    required this.label,
    this.value,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(label),
      trailing:
          trailing ??
          (value != null
              ? Text(value!, style: AppTextStyles.body2)
              : const Icon(Icons.chevron_right)),
      onTap: onTap,
    );
  }
}
