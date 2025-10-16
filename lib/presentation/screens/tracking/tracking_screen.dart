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
    final currentAsync = ref.watch(currentTrackingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Today'),
      ),
      body: currentAsync.when(
        data: (data) {
          // populate fields once when data arrives (simple approach)
          _populateFrom(data);
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                _Section(title: 'Nutrition', children: [
                  Row(children: [
                    Expanded(
                        child: _numberField(_caloriesCtrl, label: 'Calories')),
                    const SizedBox(width: 12),
                    Expanded(
                        child:
                            _decimalField(_proteinCtrl, label: 'Protein (g)')),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(
                        child: _numberField(_vegetablesCtrl,
                            label: 'Vegetables (servings)')),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _switchTile(
                        value: _fastingCompleted,
                        onChanged: (v) => setState(() => _fastingCompleted = v),
                        label: 'Fasting completed',
                      ),
                    ),
                  ]),
                ]),
                const SizedBox(height: 16),
                _Section(title: 'Exercise', children: [
                  _numberField(_exerciseMinutesCtrl, label: 'Total minutes'),
                ]),
                const SizedBox(height: 16),
                _Section(title: 'Sleep', children: [
                  Row(children: [
                    Expanded(
                        child: _decimalField(_sleepHoursCtrl,
                            label: 'Hours slept')),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _numberField(_sleepQualityCtrl,
                            label: 'Quality (1-10)')),
                  ]),
                ]),
                const SizedBox(height: 16),
                _Section(title: 'Stress', children: [
                  Row(children: [
                    Expanded(
                        child: _numberField(_stressLevelCtrl,
                            label: 'Stress (1-10)')),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _switchTile(
                        value: _meditated,
                        onChanged: (v) => setState(() => _meditated = v),
                        label: 'Meditated',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  _numberField(_meditationMinutesCtrl,
                      label: 'Meditation minutes'),
                ]),
                const SizedBox(height: 16),
                _Section(title: 'Supplements', children: [
                  _textField(_supplementsCtrl,
                      label: 'Supplements (comma separated)'),
                ]),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _save,
                    child: const Text('Save Today'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
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
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }
}
