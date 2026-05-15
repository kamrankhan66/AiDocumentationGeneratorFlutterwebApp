import 'project_info.dart';

class Documentation {
  final String readme;
  final String architecture;
  final String apiDocs;
  final String flowExplanation;
  final String suggestions;
  final DateTime generatedAt;
  
  Documentation({
    required this.readme,
    required this.architecture,
    required this.apiDocs,
    required this.flowExplanation,
    required this.suggestions,
    required this.generatedAt,
  });
  
  Map<String, dynamic> toJson() => {
    'readme': readme,
    'architecture': architecture,
    'apiDocs': apiDocs,
    'flowExplanation': flowExplanation,
    'suggestions': suggestions,
    'generatedAt': generatedAt.toIso8601String(),
  };
  
  factory Documentation.fromJson(Map<String, dynamic> json) => Documentation(
    readme: json['readme'] as String,
    architecture: json['architecture'] as String,
    apiDocs: json['apiDocs'] as String,
    flowExplanation: json['flowExplanation'] as String,
    suggestions: json['suggestions'] as String,
    generatedAt: DateTime.parse(json['generatedAt'] as String),
  );
  
  factory Documentation.empty() => Documentation(
    readme: '',
    architecture: '',
    apiDocs: '',
    flowExplanation: '',
    suggestions: '',
    generatedAt: DateTime.now(),
  );
}

class AnalysisResult {
  final ProjectInfo? projectInfo;
  final Documentation? documentation;
  final List<String> errors;
  final bool isSuccess;
  final String? message;
  
  AnalysisResult({
    this.projectInfo,
    this.documentation,
    this.errors = const [],
    required this.isSuccess,
    this.message,
  });
  
  factory AnalysisResult.success({
    required ProjectInfo projectInfo,
    required Documentation documentation,
    String? message,
  }) => AnalysisResult(
    projectInfo: projectInfo,
    documentation: documentation,
    isSuccess: true,
    message: message ?? 'Documentation generated successfully',
  );
  
  factory AnalysisResult.failure({
    required List<String> errors,
    String? message,
  }) => AnalysisResult(
    errors: errors,
    isSuccess: false,
    message: message ?? 'Failed to generate documentation',
  );
}

class ProcessingStatus {
  final String currentStep;
  final int stepIndex;
  final int totalSteps;
  final double progress;
  final String agentName;
  
  ProcessingStatus({
    required this.currentStep,
    required this.stepIndex,
    required this.totalSteps,
    required this.agentName,
  }) : progress = (stepIndex / totalSteps).clamp(0.0, 1.0);
  
  bool get isComplete => stepIndex >= totalSteps;
  
  String get progressPercentage => '${(progress * 100).toInt()}%';
}

// Made with Bob
