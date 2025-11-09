import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/tracking_provider.dart';
import '../../../domain/models/daily_tracking.dart';
import '../../../data/repositories/tracking_repository.dart';

class TrackingScreen extends ConsumerStatefulWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends ConsumerState<TrackingScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for MVP fields
  final TextEditingController _caloriesCtrl = TextEditingController();
  final TextEditingController _proteinCtrl = TextEditingController();
  final TextEditingController _vegetablesCtrl = TextEditingController();
  bool _fastingCompleted = false;

  final TextEditingController _exerciseMinutesCtrl = TextEditingController();
  final TextEditingController _sleepHoursCtrl = TextEditingController();
  final TextEditingController _sleepQualityCtrl = TextEditingController();
  final TextEditingController _stressLevelCtrl = TextEditingController();
  bool _meditated = false;
  final TextEditingController _meditationMinutesCtrl = TextEditingController();
  final TextEditingController _supplementsCtrl =
      TextEditingController(); // comma-separated

  @override
  void dispose() {
    _caloriesCtrl.dispose();
    _proteinCtrl.dispose();
    _vegetablesCtrl.dispose();
    _exerciseMinutesCtrl.dispose();
    _sleepHoursCtrl.dispose();
    _sleepQualityCtrl.dispose();
    _stressLevelCtrl.dispose();
    _meditationMinutesCtrl.dispose();
    _supplementsCtrl.dispose();
    super.dispose();
  }

  void _populateFrom(DailyTracking? data) {
    if (data == null) return;
    if (data.nutrition != null) {
      _caloriesCtrl.text = data.nutrition!.caloriesConsumed.toString();
      _proteinCtrl.text = data.nutrition!.proteinGrams.toString();
      _vegetablesCtrl.text = data.nutrition!.vegetables.toString();
      _fastingCompleted = data.nutrition!.fastingCompleted;
    }
    if (data.exercise != null) {
      _exerciseMinutesCtrl.text = data.exercise!.totalMinutes.toString();
    }
    if (data.sleep != null) {
      _sleepHoursCtrl.text = data.sleep!.hoursSlept.toString();
      _sleepQualityCtrl.text = data.sleep!.sleepQuality.toString();
    }
    if (data.stress != null) {
      _stressLevelCtrl.text = data.stress!.stressLevel.toString();
      _meditated = data.stress!.meditated;
      _meditationMinutesCtrl.text = data.stress!.meditationMinutes.toString();
    }
    if (data.supplements != null) {
      _supplementsCtrl.text = data.supplements!.supplementsTaken.join(', ');
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final repository = ref.read(trackingRepositoryProvider);
    final today = ref.read(selectedDateProvider);

    final nutrition = (_caloriesCtrl.text.isEmpty &&
            _proteinCtrl.text.isEmpty &&
            _vegetablesCtrl.text.isEmpty)
        ? null
        : NutritionLog(
            caloriesConsumed: int.tryParse(_caloriesCtrl.text) ?? 0,
            proteinGrams: double.tryParse(_proteinCtrl.text) ?? 0,
            vegetables: int.tryParse(_vegetablesCtrl.text) ?? 0,
            fastingCompleted: _fastingCompleted,
          );

    final exercise = _exerciseMinutesCtrl.text.isEmpty
        ? null
        : ExerciseLog(
            totalMinutes: int.tryParse(_exerciseMinutesCtrl.text) ?? 0,
            sessions: const []);

    final sleep =
        (_sleepHoursCtrl.text.isEmpty && _sleepQualityCtrl.text.isEmpty)
            ? null
            : SleepLog(
                hoursSlept: double.tryParse(_sleepHoursCtrl.text) ?? 0,
                sleepQuality: int.tryParse(_sleepQualityCtrl.text) ?? 0,
              );

    final stress = (_stressLevelCtrl.text.isEmpty &&
            _meditationMinutesCtrl.text.isEmpty)
        ? null
        : StressLog(
            stressLevel: int.tryParse(_stressLevelCtrl.text) ?? 0,
            meditated: _meditated,
            meditationMinutes: int.tryParse(_meditationMinutesCtrl.text) ?? 0,
          );

    final supplements = _supplementsCtrl.text.trim().isEmpty
        ? null
        : SupplementLog(
            supplementsTaken: _supplementsCtrl.text
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList(),
          );

    final toSave = DailyTracking(
      date: today,
      nutrition: nutrition,
      exercise: exercise,
      sleep: sleep,
      stress: stress,
      supplements: supplements,
    );

    await repository.saveTracking(toSave);
    // Refresh current provider
    ref.invalidate(currentTrackingProvider);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final trackingAsync = ref.watch(trackingRepositoryProvider).getTrackingForDate(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Your Health'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Date Navigation
          _buildDateNavigation(selectedDate),
          // Content
          Expanded(
            child: FutureBuilder<DailyTracking?>(
              future: trackingAsync,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _buildTrackingForm(snapshot.data);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateNavigation(DateTime selectedDate) {
    final isToday = selectedDate.year == DateTime.now().year &&
        selectedDate.month == DateTime.now().month &&
        selectedDate.day == DateTime.now().day;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              ref.read(selectedDateProvider.notifier).updateDate(
                selectedDate.subtract(const Duration(days: 1)),
              );
            },
          ),
          Column(
            children: [
              Text(
                isToday ? 'Today' : _formatDate(selectedDate),
                style: AppTextStyles.h3,
              ),
              if (!isToday)
                Text(
                  _formatDateFull(selectedDate),
                  style: AppTextStyles.caption.copyWith(color: Colors.grey.shade600),
                ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: isToday ? Colors.grey.shade400 : null,
            ),
            onPressed: isToday ? null : () {
              ref.read(selectedDateProvider.notifier).updateDate(
                selectedDate.add(const Duration(days: 1)),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }

  String _formatDateFull(DateTime date) {
    final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: ref.read(selectedDateProvider),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      ref.read(selectedDateProvider.notifier).updateDate(picked);
    }
  }

  Widget _buildTrackingForm(DailyTracking? data) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildNutritionSection(data),
          const SizedBox(height: AppSpacing.lg),
          _buildExerciseSection(data),
          const SizedBox(height: AppSpacing.lg),
          _buildSleepSection(data),
          const SizedBox(height: AppSpacing.lg),
          _buildStressSection(data),
          const SizedBox(height: AppSpacing.lg),
          _buildSupplementsSection(data),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _save,
              child: const Text('Save'),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildNutritionSection(DailyTracking? data) {
    _populateFrom(data);
    return _Section(
      title: 'Nutrition',
      icon: Icons.restaurant,
      color: AppTheme.secondaryColor,
      children: [
        Row(children: [
          Expanded(child: _numberField(_caloriesCtrl, label: 'Calories')),
          const SizedBox(width: 12),
          Expanded(child: _decimalField(_proteinCtrl, label: 'Protein (g)')),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _numberField(_vegetablesCtrl, label: 'Vegetables (servings)')),
          const SizedBox(width: 12),
          Expanded(
            child: _switchTile(
              value: _fastingCompleted,
              onChanged: (v) => setState(() => _fastingCompleted = v),
              label: 'Fasting',
            ),
          ),
        ]),
      ],
    );
  }

  Widget _buildExerciseSection(DailyTracking? data) {
    return _Section(
      title: 'Exercise',
      icon: Icons.fitness_center,
      color: AppTheme.primaryColor,
      children: [
        _numberField(_exerciseMinutesCtrl, label: 'Total minutes'),
        const SizedBox(height: 12),
        Text('Quick add:', style: AppTextStyles.caption.copyWith(color: Colors.grey.shade600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _QuickAddButton(label: '20 min', onTap: () => _addMinutes(20)),
            _QuickAddButton(label: '30 min', onTap: () => _addMinutes(30)),
            _QuickAddButton(label: '45 min', onTap: () => _addMinutes(45)),
            _QuickAddButton(label: '60 min', onTap: () => _addMinutes(60)),
          ],
        ),
      ],
    );
  }

  void _addMinutes(int minutes) {
    final current = int.tryParse(_exerciseMinutesCtrl.text) ?? 0;
    _exerciseMinutesCtrl.text = (current + minutes).toString();
  }

  Widget _buildSleepSection(DailyTracking? data) {
    final quality = int.tryParse(_sleepQualityCtrl.text) ?? 5;
    return _Section(
      title: 'Sleep',
      icon: Icons.bed,
      color: Colors.blue,
      children: [
        _decimalField(_sleepHoursCtrl, label: 'Hours slept'),
        const SizedBox(height: 12),
        Text('Sleep quality:', style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(10, (index) {
            final value = index + 1;
            final isSelected = quality == value;
            return InkWell(
              onTap: () {
                setState(() {
                  _sleepQualityCtrl.text = value.toString();
                });
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStressSection(DailyTracking? data) {
    final stressLevel = int.tryParse(_stressLevelCtrl.text) ?? 5;
    return _Section(
      title: 'Stress & Mood',
      icon: Icons.self_improvement,
      color: AppTheme.accentColor,
      children: [
        Text('Stress level:', style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _MoodButton(emoji: '😌', label: 'Low', level: 2, current: stressLevel, onTap: () => setState(() => _stressLevelCtrl.text = '2')),
            _MoodButton(emoji: '😐', label: 'Med', level: 5, current: stressLevel, onTap: () => setState(() => _stressLevelCtrl.text = '5')),
            _MoodButton(emoji: '😰', label: 'High', level: 8, current: stressLevel, onTap: () => setState(() => _stressLevelCtrl.text = '8')),
            _MoodButton(emoji: '😫', label: 'Very', level: 10, current: stressLevel, onTap: () => setState(() => _stressLevelCtrl.text = '10')),
          ],
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: _switchTile(
              value: _meditated,
              onChanged: (v) => setState(() => _meditated = v),
              label: 'Meditated',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: _numberField(_meditationMinutesCtrl, label: 'Minutes')),
        ]),
      ],
    );
  }

  Widget _buildSupplementsSection(DailyTracking? data) {
    return _Section(
      title: 'Supplements',
      icon: Icons.medication,
      color: Colors.purple,
      children: [
        _textField(_supplementsCtrl, label: 'Supplements (comma separated)'),
      ],
    );
  }

  Widget _textField(TextEditingController controller, {required String label}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _numberField(TextEditingController controller,
      {required String label}) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _decimalField(TextEditingController controller,
      {required String label}) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _switchTile(
      {required bool value,
      required void Function(bool) onChanged,
      required String label}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: AppBorderRadius.small,
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        value: value,
        onChanged: onChanged,
        title: Text(label),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final IconData? icon;
  final Color? color;

  const _Section({
    required this.title,
    required this.children,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: (color ?? AppTheme.primaryColor).withOpacity(0.05),
        borderRadius: AppBorderRadius.large,
        border: Border.all(
          color: (color ?? AppTheme.primaryColor).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (color ?? AppTheme.primaryColor).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color ?? AppTheme.primaryColor, size: 20),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                title,
                style: AppTextStyles.h3.copyWith(color: color ?? AppTheme.primaryColor),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickAddButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: AppTextStyles.body2.copyWith(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _MoodButton extends StatelessWidget {
  final String emoji;
  final String label;
  final int level;
  final int current;
  final VoidCallback onTap;

  const _MoodButton({
    required this.emoji,
    required this.label,
    required this.level,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = current == level;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.accentColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.w600 : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
