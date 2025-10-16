// lib/presentation/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.primaryColor,
                  child: const Text(
                    'A',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Alex Johnson', style: AppTextStyles.h2),
                Text(
                  '35 years old',
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.grey.shade600,
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
                icon: Icons.height,
                label: 'Height',
                value: '175 cm',
              ),
              _ProfileItem(
                icon: Icons.monitor_weight,
                label: 'Weight',
                value: '75 kg',
              ),
              _ProfileItem(
                icon: Icons.bloodtype,
                label: 'Blood Type',
                value: 'O+',
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
