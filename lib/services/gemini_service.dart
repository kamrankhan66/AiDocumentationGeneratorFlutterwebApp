import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/app_constants.dart';
import '../models/documentation.dart';
import '../models/project_info.dart';

class GeminiService {
  static const String _baseUrl = AppConstants.geminiApiUrl;
  static const String _apiKey = AppConstants.geminiApiKey;

  Future<String> answerCodebaseQuestion(
    String question,
    ProjectInfo projectInfo, {
    String? currentFileName,
    String? currentFileContent,
    List<Map<String, String>>? conversationHistory,
  }) async {
    // Build conversation context
    String conversationContext = '';
    if (conversationHistory != null && conversationHistory.isNotEmpty) {
      conversationContext = '\n\nPrevious Conversation:\n';
      for (var msg in conversationHistory) {
        conversationContext += '${msg['role']}: ${msg['message']}\n';
      }
    }

    // Build current file context
    String fileContext = '';
    if (currentFileName != null && currentFileContent != null) {
      fileContext =
          '''

Currently Viewing File: $currentFileName
File Content:
```
${currentFileContent.length > 2000 ? '${currentFileContent.substring(0, 2000)}...' : currentFileContent}
```
''';
    }

    final prompt =
        '''
${AppConstants.systemPrompt}

You are an expert software engineer helping developers understand their codebase.

Project Information:
- Name: ${projectInfo.projectName}
- Type: ${projectInfo.projectType}
- Architecture: ${projectInfo.architecture ?? 'Not specified'}
- Features: ${projectInfo.features.join(', ')}
$fileContext
$conversationContext

Developer Question: $question

Provide a detailed, helpful answer that:
1. Directly addresses the question in context of the current file/conversation
2. References the current file when relevant
3. Explains the implementation approach
4. Provides code examples if helpful
5. Maintains conversation continuity

Be conversational and helpful, like a senior engineer mentoring a junior developer.
Answer specifically about the current file if the question refers to "this" or "it".
''';

    return await _generateContent(prompt);
  }

  Future<String> explainFile(
    String filename,
    String content,
    ProjectInfo projectInfo,
  ) async {
    final prompt =
        '''
${AppConstants.systemPrompt}

Explain this file in detail:

Filename: $filename
Project Context: ${projectInfo.projectName} (${projectInfo.projectType})

File Content:
```
$content
```

Provide:
1. Purpose of this file
2. Key functionality
3. How it fits in the project architecture
4. Dependencies and relationships
5. Potential improvements
''';

    return await _generateContent(prompt);
  }

  Future<String> generateApiDoc(ProjectInfo projectInfo) async {
    final prompt =
        '''
${AppConstants.systemPrompt}

${AppConstants.apiPrompt.replaceAll('{project_info}', projectInfo.toContextString())}
''';

    return await _generateContent(prompt);
  }

  Future<String> generateArchitectureDoc(ProjectInfo projectInfo) async {
    final prompt =
        '''
${AppConstants.systemPrompt}

${AppConstants.architecturePrompt.replaceAll('{project_info}', projectInfo.toContextString())}
''';

    return await _generateContent(prompt);
  }

  Future<String> generateFlowExplanation(ProjectInfo projectInfo) async {
    final prompt =
        '''
${AppConstants.systemPrompt}

${AppConstants.flowPrompt.replaceAll('{project_info}', projectInfo.toContextString())}
''';

    return await _generateContent(prompt);
  }

  Future<Documentation> generateFullDocumentation(
    ProjectInfo projectInfo,
    Function(String, String)? onProgress,
  ) async {
    try {
      // Generate README
      onProgress?.call(AppConstants.readmeAgent, 'Generating README...');
      final readme = await generateReadme(projectInfo);

      // Generate Architecture Documentation
      onProgress?.call(
        AppConstants.structureAgent,
        'Analyzing architecture...',
      );
      final architecture = await generateArchitectureDoc(projectInfo);

      // Generate API Documentation
      onProgress?.call(AppConstants.apiAgent, 'Creating API documentation...');
      final apiDocs = await generateApiDoc(projectInfo);

      // Generate Flow Explanation
      onProgress?.call(AppConstants.flowAgent, 'Explaining project flows...');
      final flowExplanation = await generateFlowExplanation(projectInfo);

      // Generate Suggestions
      onProgress?.call(
        AppConstants.suggestionAgent,
        'Generating improvement suggestions...',
      );
      final suggestions = await generateSuggestions(projectInfo);

      return Documentation(
        readme: readme,
        architecture: architecture,
        apiDocs: apiDocs,
        flowExplanation: flowExplanation,
        suggestions: suggestions,
        generatedAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to generate documentation: $e');
    }
  }

  Future<String> generateReadme(ProjectInfo projectInfo) async {
    final prompt =
        '''
${AppConstants.systemPrompt}

${AppConstants.readmePrompt.replaceAll('{project_info}', projectInfo.toContextString())}
''';

    return await _generateContent(prompt);
  }

  Future<String> generateSuggestions(ProjectInfo projectInfo) async {
    final prompt =
        '''
${AppConstants.systemPrompt}

${AppConstants.suggestionPrompt.replaceAll('{project_info}', projectInfo.toContextString())}
''';

    return await _generateContent(prompt);
  }

  Future<String> _generateContent(String prompt) async {
    try {
      final url = Uri.parse('$_baseUrl?key=$_apiKey');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 8192,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text =
            data['candidates'][0]['content']['parts'][0]['text'] as String;
        return text;
      } else {
        throw Exception(
          'Failed to generate content: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error calling Gemini API: $e');
    }
  }
}

// Made with Bob
