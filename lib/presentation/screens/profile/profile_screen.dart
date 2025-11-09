// lib/presentation/screens/profile/profile_screen.dart
// This is now a wrapper that uses the enhanced profile screen
export 'profile_screen_enhanced.dart' show ProfileScreenEnhanced;

// For backward compatibility, use the enhanced version as the default
import 'profile_screen_enhanced.dart';

class ProfileScreen extends ProfileScreenEnhanced {
  const ProfileScreen({Key? key}) : super(key: key);
}
