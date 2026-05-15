import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // API Configuration
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  static const String geminiApiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent';
  // App Information
  static const String appName = 'AI Documentation Generator';
  static const String appVersion = '1.0.0';

  // File Size Limits
  static const int maxUploadSizeBytes = 50 * 1024 * 1024; // 50MB

  // File Patterns to Include
  static const List<String> importantFilePatterns = [
    'pubspec.yaml',
    'package.json',
    'README.md',
    'main.dart',
    'main.js',
    'index.js',
    'app.js',
    'App.tsx',
    'App.jsx',
  ];

  // Directories to Include (Flutter)
  static const List<String> flutterImportantDirs = ['lib/', 'test/'];

  // Directories to Include (React/Node)
  static const List<String> webImportantDirs = [
    'src/',
    'components/',
    'pages/',
    'routes/',
    'api/',
    'services/',
    'utils/',
    'controllers/',
    'models/',
  ];

  // Directories to Ignore
  static const List<String> ignoredDirectories = [
    'build/',
    '.git/',
    '.dart_tool/',
    'android/build/',
    'ios/build/',
    'node_modules/',
    '.gradle/',
    'dist/',
    'out/',
    '.next/',
    'coverage/',
    '.idea/',
    '.vscode/',
    'vendor/',
    'target/',
    'bin/',
    'obj/',
  ];

  // File Extensions to Ignore
  static const List<String> ignoredExtensions = [
    '.png',
    '.jpg',
    '.jpeg',
    '.gif',
    '.svg',
    '.ico',
    '.ttf',
    '.woff',
    '.woff2',
    '.eot',
    '.mp4',
    '.mp3',
    '.pdf',
    '.zip',
    '.tar',
    '.gz',
    '.exe',
    '.dll',
    '.so',
    '.dylib',
  ];

  // Important File Extensions
  static const List<String> codeFileExtensions = [
    '.dart',
    '.js',
    '.jsx',
    '.ts',
    '.tsx',
    '.py',
    '.java',
    '.kt',
    '.swift',
    '.go',
    '.rs',
    '.cpp',
    '.c',
    '.h',
    '.cs',
    '.php',
    '.rb',
    '.vue',
    '.yaml',
    '.yml',
    '.json',
    '.xml',
  ];

  // Max File Size (5MB per file)
  static const int maxFileSizeBytes = 5 * 1024 * 1024;

  // Max Files to Analyze
  static const int maxFilesToAnalyze = 100;

  // AI Processing Steps
  static const List<String> processingSteps = [
    'Extracting project files...',
    'Analyzing project structure...',
    'Detecting architecture pattern...',
    'Scanning dependencies...',
    'Analyzing code files...',
    'Generating README...',
    'Creating API documentation...',
    'Explaining project flow...',
    'Generating improvement suggestions...',
    'Analyzing security...',
    'Finalizing documentation...',
  ];

  // Agent Names
  static const String structureAgent = 'Structure Analysis Agent';
  static const String readmeAgent = 'README Generator Agent';
  static const String apiAgent = 'API Documentation Agent';
  static const String flowAgent = 'Flow Explanation Agent';
  static const String suggestionAgent = 'Improvement Suggestion Agent';

  // Prompt Templates
  static const String systemPrompt = '''
You are a senior software architect and technical documentation expert.
Analyze the provided project and generate comprehensive, professional documentation.
Be precise, technical, and provide actionable insights.
Format your response in clean markdown.
''';

  static const String readmePrompt = '''
Generate a professional README.md for this project.

Include:
1. Project Title and Description
2. Features List
3. Tech Stack
4. Prerequisites
5. Installation Instructions
6. Usage Guide
7. Project Structure
8. Dependencies Explanation
9. Contributing Guidelines
10. License

Project Information:
{project_info}

Make it professional and comprehensive.
''';

  static const String architecturePrompt = '''
Analyze and explain the architecture of this project.

Include:
1. Architecture Pattern (MVC, MVVM, Clean Architecture, BLoC, etc.)
2. Layer Explanation
3. Design Patterns Used
4. State Management Approach
5. Data Flow
6. Dependency Injection
7. Code Organization

Project Information:
{project_info}

Be technical and detailed.
''';

  static const String apiPrompt = '''
Analyze and document ONLY the actual API endpoints found in this project's code.

IMPORTANT RULES:
1. DO NOT create fake or example APIs
2. ONLY document APIs that exist in the provided code files
3. If no API files are found, state "No API endpoints detected in this project"
4. Look for actual HTTP calls, API routes, or service files

For each REAL API endpoint found, document:
1. Endpoint URL/Path
2. HTTP Method (GET, POST, PUT, DELETE)
3. Request Parameters
4. Response Format
5. Where it's used in the code

Project Information:
{project_info}

Be accurate - only document what actually exists in the code.
''';

  static const String flowPrompt = '''
Explain the key flows in this project.

Include:
1. Authentication Flow
2. Data Flow
3. Navigation Flow
4. State Management Flow
5. API Integration Flow
6. Error Handling Flow

Project Information:
{project_info}

Use diagrams in text format where helpful.
''';

  static const String suggestionPrompt = '''
Provide improvement suggestions for this project.

Analyze:
1. Code Quality
2. Architecture Improvements
3. Performance Optimization
4. Security Enhancements
5. Scalability Recommendations
6. Best Practices
7. Refactoring Opportunities
8. Testing Strategy

Project Information:
{project_info}

Be constructive and actionable.
''';
}

// Made with Bob
