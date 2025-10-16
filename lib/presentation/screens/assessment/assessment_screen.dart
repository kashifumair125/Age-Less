// lib/presentation/screens/assessment/assessment_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';

class AssessmentScreen extends ConsumerStatefulWidget {
  const AssessmentScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends ConsumerState<AssessmentScreen> {
  int currentSection = 0;
  final PageController _pageController = PageController();

  final Map<String, dynamic> assessmentData = {};

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
              Text(
                '${((currentSection / sections.length) * 100).toInt()}%',
                style: AppTextStyles.body2.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
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
    if (currentSection < sections.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousSection() {
    if (currentSection > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeAssessment() {
    // Calculate biological age and show results
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assessment Complete!'),
        content: const Text(
          'Your biological age has been calculated. View your personalized recommendations on the dashboard.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('View Results'),
          ),
        ],
      ),
    );
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
