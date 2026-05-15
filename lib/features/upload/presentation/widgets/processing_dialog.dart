import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../models/documentation.dart';

class ProcessingDialog extends StatefulWidget {
  final Future<void> Function(Function(ProcessingStatus) onProgress) onProcess;

  const ProcessingDialog({super.key, required this.onProcess});

  @override
  State<ProcessingDialog> createState() => _ProcessingDialogState();
}

class _ProcessingDialogState extends State<ProcessingDialog> {
  ProcessingStatus? _currentStatus;
  bool isComplete = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        decoration: AppTheme.cardDecoration(),
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // AI Icon with animation
            Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 50,
                    color: Colors.white,
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(duration: 2000.ms)
                .shake(duration: 2000.ms, hz: 0.5),

            const SizedBox(height: 32),

            // Title
            Text(
              'AI is Analyzing Your Project',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Current Agent
            if (_currentStatus != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: AppTheme.accentGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _currentStatus!.agentName,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ).animate().fadeIn(duration: 300.ms).scale(duration: 300.ms),

              const SizedBox(height: 24),

              // Current Step
              Text(
                _currentStatus!.currentStep,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 24),

              // Progress Bar
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _currentStatus!.progress,
                      minHeight: 8,
                      backgroundColor: AppTheme.surfaceColor,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentStatus!.progressPercentage,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Agent Workflow Visualization
              _buildAgentWorkflow(),
            ] else ...[
              const SizedBox(height: 24),
              const CircularProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _startProcessing();
  }

  Widget _buildAgentWorkflow() {
    final agents = [
      {'name': 'Structure', 'icon': Icons.folder_outlined},
      {'name': 'README', 'icon': Icons.description_outlined},
      {'name': 'API', 'icon': Icons.api_outlined},
      {'name': 'Flow', 'icon': Icons.account_tree_outlined},
      {'name': 'Suggestions', 'icon': Icons.lightbulb_outline},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: agents.asMap().entries.map((entry) {
        final index = entry.key;
        final agent = entry.value;
        final isActive =
            _currentStatus != null &&
            _currentStatus!.stepIndex >=
                index + 4; // Adjust based on your steps
        final isCompleted =
            _currentStatus != null && _currentStatus!.stepIndex > index + 4;

        return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppTheme.successColor.withValues(alpha: 0.2)
                    : isActive
                    ? AppTheme.primaryColor.withValues(alpha: 0.2)
                    : AppTheme.surfaceColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCompleted
                      ? AppTheme.successColor
                      : isActive
                      ? AppTheme.primaryColor
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isCompleted
                        ? Icons.check_circle
                        : agent['icon'] as IconData,
                    size: 16,
                    color: isCompleted
                        ? AppTheme.successColor
                        : isActive
                        ? AppTheme.primaryColor
                        : AppTheme.textTertiary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    agent['name'] as String,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isCompleted
                          ? AppTheme.successColor
                          : isActive
                          ? AppTheme.primaryColor
                          : AppTheme.textTertiary,
                      fontWeight: isActive
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            )
            .animate()
            .fadeIn(delay: (index * 100).ms, duration: 300.ms)
            .scale(delay: (index * 100).ms, duration: 300.ms);
      }).toList(),
    );
  }

  Future<void> _startProcessing() async {
    try {
      await widget.onProcess((status) {
        if (mounted) {
          setState(() {
            _currentStatus = status;
            isComplete = status.isComplete;
          });
        }
      });

      // Wait a bit before closing
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}

// Made with Bob
