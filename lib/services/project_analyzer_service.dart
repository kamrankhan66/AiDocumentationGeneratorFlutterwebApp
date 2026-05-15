import 'dart:convert';
import 'dart:typed_data';
import '../models/project_info.dart';
import '../models/documentation.dart';
import 'file_extraction_service.dart';
import 'gemini_service.dart';

class ProjectAnalyzerService {
  final FileExtractionService _fileExtractor = FileExtractionService();
  final GeminiService _geminiService = GeminiService();
  
  /// Analyze a project ZIP file and generate documentation
  Future<AnalysisResult> analyzeProject(
    Uint8List zipBytes,
    Function(ProcessingStatus)? onProgress,
  ) async {
    try {
      // Step 1: Extract files
      _updateProgress(onProgress, 'Extracting project files...', 0, 11, 'File Extractor');
      final extractedFiles = await _fileExtractor.extractZipFile(zipBytes);
      
      if (extractedFiles.isEmpty) {
        return AnalysisResult.failure(
          errors: ['No valid files found in the ZIP archive'],
          message: 'The ZIP file appears to be empty or contains no supported files',
        );
      }
      
      // Step 2: Analyze project structure
      _updateProgress(onProgress, 'Analyzing project structure...', 1, 11, 'Structure Analyzer');
      final projectInfo = await _analyzeProjectStructure(extractedFiles);
      
      // Step 3: Detect architecture
      _updateProgress(onProgress, 'Detecting architecture pattern...', 2, 11, 'Architecture Detector');
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Step 4: Scan dependencies
      _updateProgress(onProgress, 'Scanning dependencies...', 3, 11, 'Dependency Scanner');
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Step 5: Generate documentation using AI
      _updateProgress(onProgress, 'Generating README...', 4, 11, 'README Agent');
      final readme = await _geminiService.generateReadme(projectInfo);
      
      _updateProgress(onProgress, 'Creating architecture documentation...', 5, 11, 'Architecture Agent');
      final architecture = await _geminiService.generateArchitectureDoc(projectInfo);
      
      _updateProgress(onProgress, 'Generating API documentation...', 6, 11, 'API Agent');
      final apiDocs = await _geminiService.generateApiDoc(projectInfo);
      
      _updateProgress(onProgress, 'Explaining project flows...', 7, 11, 'Flow Agent');
      final flowExplanation = await _geminiService.generateFlowExplanation(projectInfo);
      
      _updateProgress(onProgress, 'Generating improvement suggestions...', 8, 11, 'Suggestion Agent');
      final suggestions = await _geminiService.generateSuggestions(projectInfo);
      
      _updateProgress(onProgress, 'Finalizing documentation...', 9, 11, 'Documentation Compiler');
      await Future.delayed(const Duration(milliseconds: 500));
      
      final documentation = Documentation(
        readme: readme,
        architecture: architecture,
        apiDocs: apiDocs,
        flowExplanation: flowExplanation,
        suggestions: suggestions,
        generatedAt: DateTime.now(),
      );
      
      _updateProgress(onProgress, 'Complete!', 10, 11, 'System');
      
      return AnalysisResult.success(
        projectInfo: projectInfo,
        documentation: documentation,
        message: 'Documentation generated successfully',
      );
    } catch (e) {
      return AnalysisResult.failure(
        errors: [e.toString()],
        message: 'Failed to analyze project: $e',
      );
    }
  }
  
  /// Analyze project structure and create ProjectInfo
  Future<ProjectInfo> _analyzeProjectStructure(Map<String, String> files) async {
    final projectName = _fileExtractor.extractProjectName(files);
    final projectType = _fileExtractor.detectProjectType(files);
    final fileStructure = _fileExtractor.getFileStructure(files);
    final importantFiles = _fileExtractor.getImportantFiles(files);
    final dependencies = _extractDependencies(files, projectType);
    final features = _detectFeatures(files, projectType);
    final architecture = _detectArchitecture(files, projectType);
    
    return ProjectInfo(
      projectName: projectName,
      projectType: projectType,
      description: _extractDescription(files),
      dependencies: dependencies,
      fileStructure: fileStructure,
      importantFiles: importantFiles,
      allFiles: files, // Include all extracted files
      architecture: architecture,
      features: features,
    );
  }
  
  /// Extract dependencies from project files
  Map<String, dynamic> _extractDependencies(Map<String, String> files, String projectType) {
    final dependencies = <String, dynamic>{};
    
    if (projectType == 'Flutter') {
      // Extract from pubspec.yaml
      for (final entry in files.entries) {
        if (entry.key.endsWith('pubspec.yaml')) {
          final lines = entry.value.split('\n');
          bool inDependencies = false;
          
          for (final line in lines) {
            if (line.trim() == 'dependencies:') {
              inDependencies = true;
              continue;
            }
            if (line.trim() == 'dev_dependencies:') {
              inDependencies = false;
            }
            
            if (inDependencies && line.trim().isNotEmpty && !line.trim().startsWith('#')) {
              if (line.contains(':')) {
                final parts = line.split(':');
                if (parts.length >= 2) {
                  final name = parts[0].trim();
                  final version = parts[1].trim();
                  if (name != 'flutter' && name != 'sdk') {
                    dependencies[name] = version;
                  }
                }
              }
            }
          }
        }
      }
    } else if (projectType.contains('Node') || projectType.contains('React')) {
      // Extract from package.json
      for (final entry in files.entries) {
        if (entry.key.endsWith('package.json')) {
          try {
            final json = jsonDecode(entry.value);
            if (json['dependencies'] != null) {
              dependencies.addAll(json['dependencies'] as Map<String, dynamic>);
            }
          } catch (e) {
            // Continue if JSON parsing fails
          }
        }
      }
    }
    
    return dependencies;
  }
  
  /// Detect features from project structure
  List<String> _detectFeatures(Map<String, String> files, String projectType) {
    final features = <String>[];
    final filePaths = files.keys.toList();
    
    // Common features
    if (filePaths.any((f) => f.contains('auth') || f.contains('login'))) {
      features.add('Authentication');
    }
    if (filePaths.any((f) => f.contains('api') || f.contains('service'))) {
      features.add('API Integration');
    }
    if (filePaths.any((f) => f.contains('database') || f.contains('db'))) {
      features.add('Database');
    }
    if (filePaths.any((f) => f.contains('notification'))) {
      features.add('Notifications');
    }
    if (filePaths.any((f) => f.contains('payment'))) {
      features.add('Payment Integration');
    }
    if (filePaths.any((f) => f.contains('chat') || f.contains('message'))) {
      features.add('Messaging');
    }
    if (filePaths.any((f) => f.contains('map') || f.contains('location'))) {
      features.add('Maps/Location');
    }
    
    // Flutter specific
    if (projectType == 'Flutter') {
      if (filePaths.any((f) => f.contains('bloc'))) {
        features.add('BLoC State Management');
      }
      if (filePaths.any((f) => f.contains('provider'))) {
        features.add('Provider State Management');
      }
      if (filePaths.any((f) => f.contains('getx'))) {
        features.add('GetX State Management');
      }
    }
    
    return features;
  }
  
  /// Detect architecture pattern
  String? _detectArchitecture(Map<String, String> files, String projectType) {
    final filePaths = files.keys.toList();
    
    if (projectType == 'Flutter') {
      if (filePaths.any((f) => f.contains('bloc'))) {
        return 'BLoC Pattern';
      }
      if (filePaths.any((f) => f.contains('domain') && f.contains('data') && f.contains('presentation'))) {
        return 'Clean Architecture';
      }
      if (filePaths.any((f) => f.contains('viewmodel'))) {
        return 'MVVM';
      }
      if (filePaths.any((f) => f.contains('provider'))) {
        return 'Provider Pattern';
      }
    }
    
    if (filePaths.any((f) => f.contains('controller') && f.contains('model') && f.contains('view'))) {
      return 'MVC';
    }
    
    return null;
  }
  
  /// Extract project description
  String? _extractDescription(Map<String, String> files) {
    // Try to get from README
    for (final entry in files.entries) {
      if (entry.key.toLowerCase().endsWith('readme.md')) {
        final lines = entry.value.split('\n');
        if (lines.length > 1) {
          return lines[1].trim();
        }
      }
    }
    
    // Try to get from package.json
    for (final entry in files.entries) {
      if (entry.key.endsWith('package.json')) {
        try {
          final json = jsonDecode(entry.value);
          if (json['description'] != null) {
            return json['description'] as String;
          }
        } catch (e) {
          // Continue if JSON parsing fails
        }
      }
    }
    
    // Try to get from pubspec.yaml
    for (final entry in files.entries) {
      if (entry.key.endsWith('pubspec.yaml')) {
        final lines = entry.value.split('\n');
        for (final line in lines) {
          if (line.trim().startsWith('description:')) {
            return line.split(':')[1].trim().replaceAll('"', '');
          }
        }
      }
    }
    
    return null;
  }
  
  /// Helper to update progress
  void _updateProgress(
    Function(ProcessingStatus)? onProgress,
    String step,
    int index,
    int total,
    String agentName,
  ) {
    if (onProgress != null) {
      onProgress(ProcessingStatus(
        currentStep: step,
        stepIndex: index,
        totalSteps: total,
        agentName: agentName,
      ));
    }
  }
}

// Made with Bob
