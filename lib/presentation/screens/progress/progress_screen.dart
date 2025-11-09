// lib/presentation/screens/progress/progress_screen.dart
// This is now a wrapper that uses the enhanced progress screen
export 'progress_screen_enhanced.dart' show ProgressScreenEnhanced;

// For backward compatibility, use the enhanced version as the default
import 'progress_screen_enhanced.dart';

class ProgressScreen extends ProgressScreenEnhanced {
  const ProgressScreen({Key? key}) : super(key: key);
}
