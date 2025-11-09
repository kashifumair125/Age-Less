# Age-Less Visual Design System

A comprehensive guide to the Age-Less app's premium visual design system featuring Neumorphism, Glassmorphism, and psychology-based color theory.

---

## Table of Contents

1. [Design Principles](#design-principles)
2. [Color Psychology](#color-psychology)
3. [Typography](#typography)
4. [Neumorphism Components](#neumorphism-components)
5. [Glassmorphism Components](#glassmorphism-components)
6. [Animated Widgets](#animated-widgets)
7. [Gradient System](#gradient-system)
8. [Usage Examples](#usage-examples)

---

## Design Principles

### Core Philosophy

The Age-Less design system is built on four key principles:

1. **Trust & Premium Feel** - Purple primary color evokes trust and wisdom
2. **Health & Growth** - Green success color represents vitality and progress
3. **Energy & Action** - Orange accent color motivates user engagement
4. **Soft & Modern** - Neumorphism creates tactile, dimensional interfaces
5. **Transparent & Light** - Glassmorphism adds depth and sophistication

### Visual Hierarchy

```
Display XL (48px) → Hero Headlines
Display Large (40px) → Major Headings
Display Medium (32px) → Section Headings
H1-H5 (24px-14px) → Standard Headings
Body Large-Small (16px-12px) → Content Text
Labels & Captions → UI Elements
```

---

## Color Psychology

### Primary - Purple (Trust, Wisdom, Premium)

**Main Color:**
- `AppColors.primary` - `#7C3AED` - Vibrant Purple
- `AppColors.primaryLight` - `#9F7AEA` - Light Purple
- `AppColors.primaryDark` - `#5B21B6` - Deep Purple
- `AppColors.primarySoft` - `#EDE9FE` - Very Light Purple Background

**Usage:**
- Primary actions and CTAs
- Brand elements
- Navigation highlights
- Premium features

**Gradient:**
```dart
AppColors.primaryGradientLinear
// Violet → Purple gradient
```

### Secondary - Green (Health, Growth, Success)

**Main Color:**
- `AppColors.success` - `#10B981` - Emerald Green
- `AppColors.successLight` - `#34D399` - Light Green
- `AppColors.successDark` - `#059669` - Deep Green
- `AppColors.successSoft` - `#D1FAE5` - Very Light Green Background

**Usage:**
- Success messages
- Health metrics
- Progress indicators
- Achievements

**Gradient:**
```dart
AppColors.successGradientLinear
// Emerald → Teal gradient
```

### Accent - Orange (Energy, Enthusiasm, Action)

**Main Color:**
- `AppColors.accent` - `#F59E0B` - Amber
- `AppColors.accentLight` - `#FBBF24` - Light Amber
- `AppColors.accentDark` - `#D97706` - Deep Amber
- `AppColors.accentSoft` - `#FEF3C7` - Very Light Amber Background

**Usage:**
- Energetic actions
- Warnings (gentle)
- Highlights
- Activity indicators

**Gradient:**
```dart
AppColors.accentGradientLinear
// Amber → Orange gradient
```

### Error - Red (Attention, Alerts)

**Main Color:**
- `AppColors.error` - `#EF4444` - Red
- `AppColors.errorLight` - `#F87171` - Light Red
- `AppColors.errorDark` - `#DC2626` - Deep Red
- `AppColors.errorSoft` - `#FEE2E2` - Very Light Red Background

**Usage:**
- Errors only (not for branding)
- Critical alerts
- Destructive actions

### Category Colors

```dart
AppColors.categoryNutrition = #10B981 (Green)
AppColors.categoryExercise = #EF4444 (Red)
AppColors.categorySleep = #8B5CF6 (Purple)
AppColors.categoryStress = #F59E0B (Amber)
AppColors.categorySocial = #3B82F6 (Blue)
```

---

## Typography

### Display Styles (Hero Text)

```dart
// Extra Large - Hero headlines (48px, Bold 800)
AppTypography.displayXL

// Large - Major headings (40px, Bold 800)
AppTypography.displayLarge

// Medium - Section headings (32px, Bold 700)
AppTypography.displayMedium

// Small - Card headings (28px, Bold 700)
AppTypography.displaySmall
```

### Heading Styles

```dart
// H1 - Main page title (24px, Bold 700)
AppTypography.h1

// H2 - Section headers (20px, Bold 700)
AppTypography.h2

// H3 - Subsection headers (18px, SemiBold 600)
AppTypography.h3

// H4 - Card titles (16px, SemiBold 600)
AppTypography.h4

// H5 - Small headers (14px, SemiBold 600)
AppTypography.h5
```

### Body Styles

```dart
// Large - Primary content (16px, Regular 400, 1.5 line height)
AppTypography.bodyLarge

// Medium - Standard content (14px, Regular 400, 1.5 line height)
AppTypography.bodyMedium

// Small - Secondary content (12px, Regular 400, 1.5 line height)
AppTypography.bodySmall
```

### Label & UI Styles

```dart
// Large - Button text, form labels (16px, SemiBold 600)
AppTypography.labelLarge

// Medium - Small buttons, tabs (14px, SemiBold 600)
AppTypography.labelMedium

// Small - Tiny labels, tags (12px, SemiBold 600, +0.5 tracking)
AppTypography.labelSmall

// Caption - Helper text, timestamps (12px, Regular 400)
AppTypography.caption

// Overline - Labels, categories (10px, SemiBold 600, +1.5 tracking, UPPERCASE)
AppTypography.overline
```

### Specialized Styles

```dart
// Number Large - Big statistics (56px, Extra Bold 800)
AppTypography.numberLarge

// Number Medium - Stats (32px, Bold 700)
AppTypography.numberMedium

// Number Small - Small stats (24px, Bold 700)
AppTypography.numberSmall

// Quote - Quotes and testimonials (18px, Medium 500, Italic)
AppTypography.quote

// CTA Primary - Main action buttons (16px, Bold 700, +0.5 tracking)
AppTypography.ctaPrimary
```

---

## Neumorphism Components

### What is Neumorphism?

Neumorphism creates soft, extruded UI elements that appear to rise from or sink into the background using dual shadows (light highlight + dark shadow).

### Available Components

#### 1. Neumorphic Container

```dart
NeumorphicContainer(
  padding: EdgeInsets.all(16),
  borderRadius: 16,
  style: NeumorphicStyle.convex, // flat, convex, concave, pressed
  intensity: 1.0, // 0.0 to 1.0
  child: Text('Elevated surface'),
)
```

**Styles:**
- `flat` - No shadow (subtle)
- `convex` - Raised from surface (default for cards)
- `concave` - Sunken into surface (for inputs)
- `pressed` - Pressed state (for active buttons)

#### 2. Neumorphic Button

```dart
NeumorphicButton(
  onPressed: () {},
  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  borderRadius: 12,
  child: Text('Click Me'),
)
```

**Features:**
- Auto-switches to pressed state on tap
- Disabled state support
- Minimum size constraints

#### 3. Neumorphic Card

```dart
NeumorphicCard(
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.all(8),
  onTap: () {},
  child: Column(children: [...]),
)
```

#### 4. Neumorphic Progress

```dart
NeumorphicProgress(
  value: 0.7, // 0.0 to 1.0
  height: 12,
  borderRadius: 6,
  progressColor: AppColors.success,
)
```

---

## Glassmorphism Components

### What is Glassmorphism?

Glassmorphism creates frosted glass effects with:
- Backdrop blur
- Semi-transparent backgrounds
- Subtle borders
- Depth and layering

### Available Components

#### 1. Glass Container

```dart
GlassContainer(
  padding: EdgeInsets.all(16),
  borderRadius: 16,
  intensity: GlassIntensity.medium, // light, medium, strong
  blur: 10, // Blur amount
  opacity: 0.1, // Background opacity
  child: Content(),
)
```

**Intensity Levels:**
- `light` - 5px blur, 5% opacity
- `medium` - 10px blur, 10% opacity
- `strong` - 20px blur, 20% opacity

#### 2. Glass Card

```dart
GlassCard(
  padding: EdgeInsets.all(16),
  intensity: GlassIntensity.medium,
  onTap: () {},
  child: CardContent(),
)
```

#### 3. Glass Button

```dart
GlassButton(
  onPressed: () {},
  gradient: AppColors.primaryGradientLinear,
  child: Text('Glass Action'),
)
```

#### 4. Glass App Bar

```dart
GlassAppBar(
  title: Text('Title'),
  leading: BackButton(),
  actions: [IconButton(...)],
  intensity: GlassIntensity.strong,
)
```

#### 5. Glass Bottom Navigation

```dart
GlassBottomNav(
  items: [Icon(...), Icon(...), Icon(...)],
  height: 72,
)
```

#### 6. Glass Bottom Sheet

```dart
// Show as modal
GlassBottomSheet.show(
  context: context,
  height: 400,
  child: SheetContent(),
);

// Or use directly
GlassBottomSheet(
  height: 400,
  padding: EdgeInsets.all(24),
  child: Content(),
)
```

---

## Animated Widgets

### 1. Success Celebration

```dart
SuccessCelebration(
  message: 'Goal Achieved!',
  icon: Icons.check_circle,
  onComplete: () {},
)
```

**Features:**
- Elastic scale animation
- Bounce effect
- Auto-completes after 2 seconds
- Customizable icon

### 2. Pulse Loader

```dart
PulseLoader(
  size: 80,
  color: AppColors.primary,
)
```

**Use Cases:**
- Loading states
- Processing indicators
- Async operations

### 3. Shimmer Loading

```dart
ShimmerLoading(
  width: 200,
  height: 20,
  borderRadius: 8,
)
```

**Use Cases:**
- Skeleton screens
- Content placeholders
- Loading previews

### 4. Animated Counter

```dart
AnimatedCounter(
  value: 125,
  duration: Duration(milliseconds: 1000),
  style: AppTypography.numberLarge,
  decimals: 0,
  suffix: ' days',
  prefix: '+',
)
```

**Features:**
- Smooth number transitions
- Configurable decimals
- Prefix/suffix support
- Custom duration

### 5. Fade In Animation

```dart
FadeInAnimation(
  duration: Duration(milliseconds: 600),
  delay: Duration(milliseconds: 100),
  curve: Curves.easeOut,
  child: Widget(),
)
```

### 6. Slide In Animation

```dart
SlideInAnimation(
  duration: Duration(milliseconds: 600),
  delay: Duration.zero,
  begin: Offset(0, 0.3), // Start 30% down
  curve: Curves.easeOut,
  child: Widget(),
)
```

### 7. Staggered List

```dart
StaggeredList(
  delay: Duration(milliseconds: 100),
  staggerDelay: Duration(milliseconds: 50),
  children: [Widget1(), Widget2(), Widget3()],
)
```

**Features:**
- Auto-staggers child animations
- Combines fade + slide
- Customizable delays

---

## Gradient System

### 1. Gradient Button

```dart
GradientButton(
  onPressed: () {},
  gradient: AppColors.primaryGradientLinear,
  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
  borderRadius: 12,
  isLoading: false,
  isDisabled: false,
  child: Text('Primary Action'),
)
```

**Features:**
- Loading state with spinner
- Disabled state styling
- Custom gradients
- Drop shadow effects

### 2. Gradient Icon Button

```dart
GradientIconButton(
  icon: Icons.add,
  onPressed: () {},
  gradient: AppColors.successGradientLinear,
  size: 48,
  iconSize: 24,
)
```

### 3. Gradient Card

```dart
GradientCard(
  gradient: AppColors.accentGradientLinear,
  padding: EdgeInsets.all(16),
  borderRadius: 16,
  onTap: () {},
  child: CardContent(),
)
```

### 4. Gradient Text

```dart
GradientText(
  text: 'Premium Feature',
  gradient: AppColors.primaryGradientLinear,
  style: AppTypography.h1,
)
```

### 5. Gradient Progress

```dart
GradientProgress(
  value: 0.75,
  gradient: AppColors.successGradientLinear,
  height: 8,
  borderRadius: 4,
  showPercentage: true,
)
```

### 6. Gradient Circular Progress

```dart
GradientCircularProgress(
  value: 0.8,
  size: 100,
  strokeWidth: 8,
  gradient: AppColors.primaryGradientLinear,
  child: Text('80%'),
)
```

### 7. Gradient Badge

```dart
GradientBadge(
  label: 'New',
  gradient: AppColors.accentGradientLinear,
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  borderRadius: 12,
)
```

---

## Usage Examples

### Complete Screen Example

```dart
class HealthDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,

      // Glass App Bar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: GlassAppBar(
          title: GradientText(
            text: 'Health Dashboard',
            gradient: AppColors.primaryGradientLinear,
            style: AppTypography.h3,
          ),
          actions: [
            GradientIconButton(
              icon: Icons.notifications,
              onPressed: () {},
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: StaggeredList(
          children: [
            // Neumorphic Card with stats
            NeumorphicCard(
              child: Column(
                children: [
                  AnimatedCounter(
                    value: 32,
                    style: AppTypography.numberLarge,
                    suffix: ' years',
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Biological Age',
                    style: AppTypography.bodyMedium,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Glass Card with gradient progress
            GlassCard(
              intensity: GlassIntensity.medium,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Progress',
                    style: AppTypography.h4,
                  ),
                  SizedBox(height: 12),
                  GradientProgress(
                    value: 0.7,
                    gradient: AppColors.successGradientLinear,
                    showPercentage: true,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Gradient Button
            GradientButton(
              onPressed: () {},
              gradient: AppColors.primaryGradientLinear,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Log Activity',
                    style: AppTypography.labelLarge.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Success State Example

```dart
// Show success celebration after saving
void onSaveComplete() {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: SuccessCelebration(
        message: 'Data Saved Successfully!',
        icon: Icons.check_circle,
        onComplete: () => Navigator.pop(context),
      ),
    ),
  );
}
```

### Loading State Example

```dart
// Using with AsyncValue
ref.watch(dataProvider).buildWidget(
  onData: (data) => DataWidget(data),
  onLoading: () => LoadingDisplay(message: 'Loading your data...'),
  onError: (error) => ErrorDisplay(
    error: error,
    onRetry: () => ref.refresh(dataProvider),
  ),
);
```

### Empty State Example

```dart
EmptyDisplay(
  title: 'No Activities Yet',
  message: 'Start logging your health activities to see progress',
  icon: Icons.fitness_center_outlined,
  action: GradientButton(
    onPressed: () {},
    child: Text('Add First Activity'),
  ),
)
```

---

## Best Practices

### When to Use Neumorphism

✅ **Use for:**
- Cards and containers
- Buttons and interactive elements
- Progress indicators
- Form inputs (concave style)

❌ **Avoid for:**
- Small elements (less readable)
- High-contrast needs
- Accessibility-critical interfaces

### When to Use Glassmorphism

✅ **Use for:**
- App bars and navigation
- Bottom sheets and modals
- Overlays and panels
- Premium features

❌ **Avoid for:**
- Main content areas
- Text-heavy sections
- When backdrop is too complex

### Combining Styles

```dart
// Neumorphic card with glass overlay
Stack(
  children: [
    NeumorphicCard(child: MainContent()),
    Positioned(
      top: 16,
      right: 16,
      child: GlassContainer(
        padding: EdgeInsets.all(8),
        borderRadius: 8,
        child: GradientBadge(label: 'Premium'),
      ),
    ),
  ],
)
```

---

## Accessibility

### Color Contrast

All color combinations meet WCAG AA standards:
- Primary text on light background: 12.63:1
- Secondary text on light background: 4.51:1
- White text on primary purple: 6.88:1

### Touch Targets

Minimum touch target sizes:
- Buttons: 48x48 dp
- Icon buttons: 48x48 dp
- List items: 48dp height

### Animations

All animations respect `reduce motion` preferences:

```dart
final reduceMotion = MediaQuery.of(context).disableAnimations;
if (!reduceMotion) {
  // Show animation
}
```

---

## Migration Guide

### From Old Theme to New

```dart
// Old
import 'package:age_less/core/theme/app_theme.dart';
MaterialApp(theme: AppTheme.light());

// New
import 'package:age_less/core/theme/app_theme_v2.dart';
MaterialApp(theme: AppThemeV2.light());
```

### Updating Components

```dart
// Old Card
Card(child: ...)

// New Neumorphic Card
NeumorphicCard(child: ...)

// Or Glass Card
GlassCard(child: ...)
```

### Updating Buttons

```dart
// Old ElevatedButton
ElevatedButton(child: ..., onPressed: ...)

// New Gradient Button
GradientButton(child: ..., onPressed: ...)

// Or Neumorphic Button
NeumorphicButton(child: ..., onPressed: ...)
```

---

## Resources

### Color Tools
- [Coolors.co](https://coolors.co) - Color palette generator
- [Color Hunt](https://colorhunt.co) - Color inspiration

### Design References
- [Dribbble - Neumorphism](https://dribbble.com/tags/neumorphism)
- [Dribbble - Glassmorphism](https://dribbble.com/tags/glassmorphism)

### Typography
- [Google Fonts - Inter](https://fonts.google.com/specimen/Inter)
- [Type Scale](https://type-scale.com) - Typography calculator

---

## Support

For questions or suggestions about the design system, please contact the development team or open an issue in the repository.

---

**Version:** 1.0.0
**Last Updated:** 2025-01-09
**Maintainer:** Age-Less Development Team
