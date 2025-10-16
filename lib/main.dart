// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'data/local/hive_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();
  await HiveConfig.initialize();

  runApp(const ProviderScope(child: AgeLessApp()));
}

class AgeLessApp extends ConsumerWidget {
  const AgeLessApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'AgeLess - Biological Age Reversal',
      debugShowCheckedModeBanner: false,
      theme: AppThemeVariants.lightTheme,
      darkTheme: AppThemeVariants.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
