// lib/presentation/screens/assessment/assessment_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/services/biological_age_calculator.dart';
import '../../../data/repositories/assessment_repository.dart';
import '../../../data/repositories/user_repository.dart';

class AssessmentScreen extends ConsumerStatefulWidget {
  const AssessmentScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends ConsumerState<AssessmentScreen> {
  int currentSection = 0;
  final PageController _pageController = PageController();
  final DateTime _startTime = DateTime.now();

  final Map<String, dynamic> assessmentData = {};

  @override
  void initState() {
    super.initState();
    _loadSavedProgress();
  }

  Future<void> _loadSavedProgress() async {
    // Load saved progress from Hive if exists
    final box = ref.read(assessmentRepositoryProvider).getProgressBox();
    final savedProgress = box.get('assessment_progress');
    if (savedProgress != null && savedProgress is Map) {
      setState(() {
        assessmentData.addAll(Map<String, dynamic>.from(savedProgress));
        final savedSection = box.get('current_section');
        if (savedSection != null && savedSection is int) {
          currentSection = savedSection;
          _pageController.jumpToPage(currentSection);
        }
      });
    }
  }

  Future<void> _saveProgress() async {
    // Save current progress to Hive
    final box = ref.read(assessmentRepositoryProvider).getProgressBox();
    await box.put('assessment_progress', assessmentData);
    await box.put('current_section', currentSection);
  }

  final List<AssessmentSection> sections = [
    AssessmentSection(
      title: 'Nutrition',
      icon: Icons.restaurant,
      color: AppTheme.secondaryColor,
      questions: [
        AssessmentQuestion(
          id: 'dietType',
          question: 'What best describes your eating pattern?',
          type: QuestionType.singleChoice,
          options: [
            'Mediterranean',
            'Plant-based',
            'Paleo',
            'Balanced',
            'Standard Western',
          ],
        ),
        AssessmentQuestion(
          id: 'vegetableServings',
          question: 'How many servings of vegetables do you eat daily?',
          type: QuestionType.number,
          unit: 'servings',
        ),
        AssessmentQuestion(
          id: 'processedFoodFrequency',
          question: 'How often do you eat processed foods?',
          type: QuestionType.singleChoice,
          options: ['Never', 'Rarely', 'Sometimes', 'Often', 'Daily'],
        ),
        AssessmentQuestion(
          id: 'intermittentFasting',
          question: 'Do you practice intermittent fasting?',
          type: QuestionType.boolean,
        ),
        AssessmentQuestion(
          id: 'sugarIntake',
          question: 'How much added sugar do you consume?',
          type: QuestionType.singleChoice,
          options: ['Very Low', 'Low', 'Moderate', 'High', 'Very High'],
        ),
      ],
    ),
    AssessmentSection(
      title: 'Exercise',
      icon: Icons.fitness_center,
      color: AppTheme.primaryColor,
      questions: [
        AssessmentQuestion(
          id: 'weeklyMinutes',
          question: 'How many minutes do you exercise per week?',
          type: QuestionType.number,
          unit: 'minutes',
        ),
        AssessmentQuestion(
          id: 'hiitSessionsPerWeek',
          question: 'HIIT training sessions per week?',
          type: QuestionType.number,
          unit: 'sessions',
        ),
        AssessmentQuestion(
          id: 'strengthSessionsPerWeek',
          question: 'Strength training sessions per week?',
          type: QuestionType.number,
          unit: 'sessions',
        ),
        AssessmentQuestion(
          id: 'averageDailySteps',
          question: 'Average daily steps?',
          type: QuestionType.number,
          unit: 'steps',
        ),
      ],
    ),
    AssessmentSection(
      title: 'Sleep',
      icon: Icons.bed,
      color: Colors.blue,
      questions: [
        AssessmentQuestion(
          id: 'averageHours',
          question: 'How many hours do you sleep per night?',
          type: QuestionType.slider,
          min: 4,
          max: 12,
          unit: 'hours',
        ),
        AssessmentQuestion(
          id: 'quality',
          question: 'Rate your sleep quality',
          type: QuestionType.scale,
          min: 1,
          max: 10,
        ),
        AssessmentQuestion(
          id: 'consistentSchedule',
          question: 'Do you maintain a consistent sleep schedule?',
          type: QuestionType.boolean,
        ),
        AssessmentQuestion(
          id: 'screenBeforeBed',
          question: 'Do you use screens within 1 hour of bedtime?',
          type: QuestionType.boolean,
        ),
      ],
    ),
    AssessmentSection(
      title: 'Stress',
      icon: Icons.self_improvement,
      color: AppTheme.accentColor,
      questions: [
        AssessmentQuestion(
          id: 'perceivedStress',
          question: 'Rate your average stress level',
          type: QuestionType.scale,
          min: 1,
          max: 10,
        ),
        AssessmentQuestion(
          id: 'regularMeditation',
          question: 'Do you practice meditation regularly?',
          type: QuestionType.boolean,
        ),
        AssessmentQuestion(
          id: 'meditationMinutesPerDay',
          question: 'If yes, how many minutes per day?',
          type: QuestionType.number,
          unit: 'minutes',
        ),
        AssessmentQuestion(
          id: 'workLifeBalance',
          question: 'Rate your work-life balance',
          type: QuestionType.scale,
          min: 1,
          max: 10,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biological Age Assessment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Progress Indicator
          _buildProgressIndicator(),

          // Question Content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sections.length,
              onPageChanged: (index) {
                setState(() {
                  currentSection = index;
                });
              },
              itemBuilder: (context, sectionIndex) {
                return _buildSectionQuestions(sections[sectionIndex]);
              },
            ),
          ),

          // Navigation Buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final elapsedMinutes = DateTime.now().difference(_startTime).inMinutes;
    final estimatedTotalMinutes = sections.length * 3; // Estimate 3 min per section
    final estimatedRemaining = estimatedTotalMinutes - elapsedMinutes;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Section ${currentSection + 1} of ${sections.length}',
                style: AppTextStyles.body2.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.timer_outlined, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    estimatedRemaining > 0
                      ? '~${estimatedRemaining} min left'
                      : 'Almost done!',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    '${((currentSection / sections.length) * 100).toInt()}%',
                    style: AppTextStyles.body2.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (currentSection + 1) / sections.length,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.primaryColor,
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionQuestions(AssessmentSection section) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: section.color.withOpacity(0.1),
              borderRadius: AppBorderRadius.large,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: section.color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(section.icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  section.title,
                  style: AppTextStyles.h2.copyWith(color: section.color),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Questions
          ...section.questions.map((question) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xl),
              child: _buildQuestion(question),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildQuestion(AssessmentQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.question,
          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.md),

        // Question Type Specific UI
        if (question.type == QuestionType.singleChoice)
          _buildSingleChoice(question)
        else if (question.type == QuestionType.boolean)
          _buildBooleanChoice(question)
        else if (question.type == QuestionType.number)
          _buildNumberInput(question)
        else if (question.type == QuestionType.scale)
          _buildScaleInput(question)
        else if (question.type == QuestionType.slider)
          _buildSliderInput(question),
      ],
    );
  }

  Widget _buildSingleChoice(AssessmentQuestion question) {
    return Column(
      children: question.options!.map((option) {
        final isSelected = assessmentData[question.id] == option;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: InkWell(
            onTap: () {
              setState(() {
                assessmentData[question.id] = option;
              });
            },
            borderRadius: AppBorderRadius.medium,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryColor
                      : Colors.grey.shade300,
                  width: 2,
                ),
                borderRadius: AppBorderRadius.medium,
                color: isSelected
                    ? AppTheme.primaryColor.withOpacity(0.05)
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isSelected
                        ? AppTheme.primaryColor
                        : Colors.grey.shade400,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    option,
                    style: AppTextStyles.body1.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBooleanChoice(AssessmentQuestion question) {
    return Row(
      children: [
        Expanded(
          child: _buildChoiceButton(
            label: 'Yes',
            isSelected: assessmentData[question.id] == true,
            onTap: () {
              setState(() {
                assessmentData[question.id] = true;
              });
            },
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildChoiceButton(
            label: 'No',
            isSelected: assessmentData[question.id] == false,
            onTap: () {
              setState(() {
                assessmentData[question.id] = false;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppBorderRadius.medium,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.grey.shade100,
          borderRadius: AppBorderRadius.medium,
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.body1.copyWith(
              color: isSelected ? Colors.white : Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberInput(AssessmentQuestion question) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Enter ${question.unit ?? 'value'}',
        suffixText: question.unit,
      ),
      onChanged: (value) {
        assessmentData[question.id] = int.tryParse(value) ?? 0;
      },
    );
  }

  Widget _buildScaleInput(AssessmentQuestion question) {
    final value = assessmentData[question.id] ?? question.min;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(question.max! - question.min! + 1, (index) {
            final scaleValue = question.min! + index;
            final isSelected = value == scaleValue;

            return InkWell(
              onTap: () {
                setState(() {
                  assessmentData[question.id] = scaleValue;
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryColor
                      : Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    scaleValue.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Low', style: AppTextStyles.caption),
            Text('High', style: AppTextStyles.caption),
          ],
        ),
      ],
    );
  }

  Widget _buildSliderInput(AssessmentQuestion question) {
    final value =
        assessmentData[question.id]?.toDouble() ?? question.min!.toDouble();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${value.toStringAsFixed(1)} ${question.unit ?? ''}',
              style: AppTextStyles.h3.copyWith(color: AppTheme.primaryColor),
            ),
          ],
        ),
        Slider(
          value: value,
          min: question.min!.toDouble(),
          max: question.max!.toDouble(),
          divisions: ((question.max! - question.min!) * 2).toInt(),
          label: value.toStringAsFixed(1),
          onChanged: (newValue) {
            setState(() {
              assessmentData[question.id] = newValue;
            });
          },
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (currentSection > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousSection,
                child: const Text('Previous'),
              ),
            ),
          if (currentSection > 0) const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: currentSection > 0 ? 1 : 1,
            child: ElevatedButton(
              onPressed: currentSection < sections.length - 1
                  ? _nextSection
                  : _completeAssessment,
              child: Text(
                currentSection < sections.length - 1
                    ? 'Next'
                    : 'Complete Assessment',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextSection() {
    // Validate current section before proceeding
    if (!_validateCurrentSection()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please answer all questions before proceeding'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    _saveProgress(); // Save progress

    if (currentSection < sections.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousSection() {
    _saveProgress(); // Save progress

    if (currentSection > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentSection() {
    final currentSectionData = sections[currentSection];
    for (final question in currentSectionData.questions) {
      if (!assessmentData.containsKey(question.id)) {
        return false;
      }
      // Check for empty or invalid values
      final value = assessmentData[question.id];
      if (value == null) return false;
      if (value is String && value.isEmpty) return false;
    }
    return true;
  }

  Future<void> _completeAssessment() async {
    // Convert assessment data to category scores (0-10 scale)
    final categoryScores = _calculateCategoryScores();

    // Get user profile
    final userRepository = ref.read(userRepositoryProvider);
    final assessmentRepository = ref.read(assessmentRepositoryProvider);
    final userProfile = await userRepository.getUserProfile();

    if (userProfile == null) {
      // Show error if no user profile exists
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Profile Required'),
          content: const Text(
            'Please set up your profile before completing the assessment.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Calculate biological age
    final calculator = BiologicalAgeCalculator();
    final assessment = calculator.calculate(
      profile: userProfile,
      categoryScores: categoryScores,
      now: DateTime.now(),
    );

    // Save assessment
    await assessmentRepository.saveAssessment(assessment);

    // Update user's current biological age
    await userRepository.updateBiologicalAge(assessment.biologicalAge);

    // Clear saved progress
    await assessmentRepository.clearProgress();

    // Show results
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Assessment Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Biological Age: ${assessment.biologicalAge.toStringAsFixed(1)} years',
              style: AppTextStyles.h3.copyWith(color: AppTheme.primaryColor),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Chronological Age: ${assessment.chronologicalAge.toStringAsFixed(1)} years',
              style: AppTextStyles.body1,
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: assessment.ageDifference < 0
                    ? Colors.green.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                borderRadius: AppBorderRadius.medium,
              ),
              child: Row(
                children: [
                  Icon(
                    assessment.ageDifference < 0
                        ? Icons.trending_down
                        : Icons.trending_up,
                    color: assessment.ageDifference < 0
                        ? Colors.green
                        : Colors.orange,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      assessment.ageDifference < 0
                          ? 'You are ${assessment.ageDifference.abs().toStringAsFixed(1)} years younger biologically!'
                          : 'Focus on your health to reduce biological age by ${assessment.ageDifference.toStringAsFixed(1)} years',
                      style: AppTextStyles.body2,
                    ),
                  ),
                ],
              ),
            ),
            if (assessment.topWeaknesses.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Focus Areas:',
                style: AppTextStyles.body1,
              ),
              const SizedBox(height: AppSpacing.sm),
              ...assessment.topWeaknesses.map(
                (weakness) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_right, size: 20),
                      Text(
                        weakness.substring(0, 1).toUpperCase() +
                            weakness.substring(1),
                        style: AppTextStyles.body2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('View Dashboard'),
          ),
        ],
      ),
    );
  }

  /// Convert raw assessment answers to category scores (0-10 scale)
  Map<String, double> _calculateCategoryScores() {
    // Nutrition scoring
    final nutritionScore = _calculateNutritionScore();

    // Exercise scoring
    final exerciseScore = _calculateExerciseScore();

    // Sleep scoring
    final sleepScore = _calculateSleepScore();

    // Stress scoring
    final stressScore = _calculateStressScore();

    return {
      'nutrition': nutritionScore,
      'exercise': exerciseScore,
      'sleep': sleepScore,
      'stress': stressScore,
      'social': 5.0, // Default neutral score for social (not assessed yet)
    };
  }

  double _calculateNutritionScore() {
    double score = 5.0; // Start at neutral

    // Diet type (0-3 points)
    final dietType = assessmentData['dietType'];
    if (dietType == 'Mediterranean') {
      score += 3;
    } else if (dietType == 'Plant-based') {
      score += 2.5;
    } else if (dietType == 'Paleo') {
      score += 2;
    } else if (dietType == 'Balanced') {
      score += 1.5;
    } else if (dietType == 'Standard Western') {
      score -= 2;
    }

    // Vegetable servings (0-2 points)
    final veggies = assessmentData['vegetableServings'] ?? 0;
    if (veggies >= 5) {
      score += 2;
    } else if (veggies >= 3) {
      score += 1;
    } else if (veggies < 2) {
      score -= 1;
    }

    // Processed food frequency (-2 to 1 points)
    final processed = assessmentData['processedFoodFrequency'];
    if (processed == 'Never') {
      score += 1;
    } else if (processed == 'Rarely') {
      score += 0.5;
    } else if (processed == 'Often' || processed == 'Daily') {
      score -= 2;
    }

    // Intermittent fasting (0-1 points)
    if (assessmentData['intermittentFasting'] == true) {
      score += 1;
    }

    // Sugar intake (-2 to 1 points)
    final sugar = assessmentData['sugarIntake'];
    if (sugar == 'Very Low') {
      score += 1;
    } else if (sugar == 'Low') {
      score += 0.5;
    } else if (sugar == 'High') {
      score -= 1;
    } else if (sugar == 'Very High') {
      score -= 2;
    }

    return score.clamp(0, 10);
  }

  double _calculateExerciseScore() {
    double score = 5.0; // Start at neutral

    // Weekly minutes (0-4 points)
    final minutes = assessmentData['weeklyMinutes'] ?? 0;
    if (minutes >= 300) {
      score += 4;
    } else if (minutes >= 150) {
      score += 3;
    } else if (minutes >= 75) {
      score += 1.5;
    } else if (minutes < 30) {
      score -= 2;
    }

    // HIIT sessions (0-2 points)
    final hiit = assessmentData['hiitSessionsPerWeek'] ?? 0;
    if (hiit >= 3) {
      score += 2;
    } else if (hiit >= 1) {
      score += 1;
    }

    // Strength training (0-2 points)
    final strength = assessmentData['strengthSessionsPerWeek'] ?? 0;
    if (strength >= 3) {
      score += 2;
    } else if (strength >= 2) {
      score += 1.5;
    } else if (strength >= 1) {
      score += 1;
    }

    // Daily steps (0-2 points)
    final steps = assessmentData['averageDailySteps'] ?? 0;
    if (steps >= 10000) {
      score += 2;
    } else if (steps >= 7000) {
      score += 1;
    } else if (steps < 3000) {
      score -= 1;
    }

    return score.clamp(0, 10);
  }

  double _calculateSleepScore() {
    double score = 5.0; // Start at neutral

    // Sleep hours (0-4 points)
    final hours = assessmentData['averageHours'] ?? 7;
    if (hours >= 7 && hours <= 9) {
      score += 4;
    } else if (hours >= 6 && hours < 7) {
      score += 2;
    } else if (hours < 6 || hours > 9) {
      score -= 2;
    }

    // Sleep quality (0-3 points)
    final quality = assessmentData['quality'] ?? 5;
    if (quality >= 8) {
      score += 3;
    } else if (quality >= 6) {
      score += 1.5;
    } else if (quality < 5) {
      score -= 2;
    }

    // Consistent schedule (0-2 points)
    if (assessmentData['consistentSchedule'] == true) {
      score += 2;
    } else {
      score -= 1;
    }

    // Screen before bed (-1 point if yes)
    if (assessmentData['screenBeforeBed'] == true) {
      score -= 1;
    } else {
      score += 1;
    }

    return score.clamp(0, 10);
  }

  double _calculateStressScore() {
    double score = 5.0; // Start at neutral

    // Perceived stress (inverse scoring: 0-5 points)
    final stress = assessmentData['perceivedStress'] ?? 5;
    score += (10 - stress) * 0.5; // Lower stress = higher score

    // Regular meditation (0-2 points)
    if (assessmentData['regularMeditation'] == true) {
      score += 2;

      // Meditation minutes bonus (0-1 points)
      final meditationMinutes = assessmentData['meditationMinutesPerDay'] ?? 0;
      if (meditationMinutes >= 20) {
        score += 1;
      } else if (meditationMinutes >= 10) {
        score += 0.5;
      }
    } else {
      score -= 1;
    }

    // Work-life balance (0-2 points)
    final balance = assessmentData['workLifeBalance'] ?? 5;
    if (balance >= 8) {
      score += 2;
    } else if (balance >= 6) {
      score += 1;
    } else if (balance < 4) {
      score -= 2;
    }

    return score.clamp(0, 10);
  }
}

// Assessment Models
class AssessmentSection {
  final String title;
  final IconData icon;
  final Color color;
  final List<AssessmentQuestion> questions;

  AssessmentSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.questions,
  });
}

class AssessmentQuestion {
  final String id;
  final String question;
  final QuestionType type;
  final List<String>? options;
  final String? unit;
  final int? min;
  final int? max;

  AssessmentQuestion({
    required this.id,
    required this.question,
    required this.type,
    this.options,
    this.unit,
    this.min,
    this.max,
  });
}

enum QuestionType { singleChoice, multiChoice, boolean, number, scale, slider }
