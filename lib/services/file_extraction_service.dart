import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import '../core/constants/app_constants.dart';

class FileExtractionService {
  /// Extract ZIP file and return filtered files
  Future<Map<String, String>> extractZipFile(Uint8List zipBytes) async {
    try {
      // Decode the ZIP archive
      final archive = ZipDecoder().decodeBytes(zipBytes);
      
      final Map<String, String> extractedFiles = {};
      int fileCount = 0;
      
      for (final file in archive) {
        // Skip if max files reached
        if (fileCount >= AppConstants.maxFilesToAnalyze) {
          break;
        }
        
        // Skip directories
        if (file.isFile) {
          final filename = file.name;
          
          // Check if file should be included
          if (_shouldIncludeFile(filename)) {
            try {
              // Get file content
              final content = file.content as List<int>;
              
              // Skip if file is too large
              if (content.length > AppConstants.maxFileSizeBytes) {
                continue;
              }
              
              // Try to decode as UTF-8 text
              try {
                final textContent = utf8.decode(content);
                extractedFiles[filename] = textContent;
                fileCount++;
              } catch (e) {
                // Skip binary files that can't be decoded
                continue;
              }
            } catch (e) {
              // Skip files that can't be processed
              continue;
            }
          }
        }
      }
      
      return extractedFiles;
    } catch (e) {
      throw Exception('Failed to extract ZIP file: $e');
    }
  }
  
  /// Check if file should be included based on patterns
  bool _shouldIncludeFile(String filepath) {
    // Check if in ignored directory
    for (final ignoredDir in AppConstants.ignoredDirectories) {
      if (filepath.contains(ignoredDir)) {
        return false;
      }
    }
    
    // Check if has ignored extension
    for (final ignoredExt in AppConstants.ignoredExtensions) {
      if (filepath.endsWith(ignoredExt)) {
        return false;
      }
    }
    
    // Check if it's an important file
    for (final pattern in AppConstants.importantFilePatterns) {
      if (filepath.endsWith(pattern) || filepath.contains(pattern)) {
        return true;
      }
    }
    
    // Check if it's a code file
    for (final ext in AppConstants.codeFileExtensions) {
      if (filepath.endsWith(ext)) {
        return true;
      }
    }
    
    // Check if in important directories
    for (final dir in AppConstants.flutterImportantDirs) {
      if (filepath.contains(dir)) {
        return true;
      }
    }
    
    for (final dir in AppConstants.webImportantDirs) {
      if (filepath.contains(dir)) {
        return true;
      }
    }
    
    return false;
  }
  
  /// Get file structure as list of paths
  List<String> getFileStructure(Map<String, String> files) {
    return files.keys.toList()..sort();
  }
  
  /// Get important files with limited content
  Map<String, String> getImportantFiles(Map<String, String> allFiles) {
    final Map<String, String> importantFiles = {};
    
    // Priority files
    final priorityPatterns = [
      'pubspec.yaml',
      'package.json',
      'README.md',
      'main.dart',
      'main.js',
      'index.js',
      'app.js',
    ];
    
    // Add priority files first
    for (final pattern in priorityPatterns) {
      for (final entry in allFiles.entries) {
        if (entry.key.endsWith(pattern)) {
          importantFiles[entry.key] = _limitContent(entry.value);
        }
      }
    }
    
    // Add other important files up to a limit
    int count = importantFiles.length;
    for (final entry in allFiles.entries) {
      if (count >= 20) break; // Limit to 20 important files
      
      if (!importantFiles.containsKey(entry.key)) {
        // Check if it's a configuration or main file
        if (entry.key.contains('config') ||
            entry.key.contains('route') ||
            entry.key.contains('service') ||
            entry.key.contains('api') ||
            entry.key.contains('model')) {
          importantFiles[entry.key] = _limitContent(entry.value);
          count++;
        }
      }
    }
    
    return importantFiles;
  }
  
  /// Limit content to reasonable size for AI processing
  String _limitContent(String content, {int maxLines = 100}) {
    final lines = content.split('\n');
    if (lines.length <= maxLines) {
      return content;
    }
    
    return lines.take(maxLines).join('\n') + '\n... [truncated]';
  }
  
  /// Extract project name from files
  String extractProjectName(Map<String, String> files) {
    // Try to get from pubspec.yaml
    for (final entry in files.entries) {
      if (entry.key.endsWith('pubspec.yaml')) {
        final lines = entry.value.split('\n');
        for (final line in lines) {
          if (line.trim().startsWith('name:')) {
            return line.split(':')[1].trim();
          }
        }
      }
    }
    
    // Try to get from package.json
    for (final entry in files.entries) {
      if (entry.key.endsWith('package.json')) {
        try {
          final json = jsonDecode(entry.value);
          if (json['name'] != null) {
            return json['name'] as String;
          }
        } catch (e) {
          // Continue if JSON parsing fails
        }
      }
    }
    
    return 'Unknown Project';
  }
  
  /// Detect project type
  String detectProjectType(Map<String, String> files) {
    final filenames = files.keys.toList();
    
    // Check for Flutter
    if (filenames.any((f) => f.endsWith('pubspec.yaml'))) {
      return 'Flutter';
    }
    
    // Check for React
    if (filenames.any((f) => f.endsWith('package.json'))) {
      final packageJson = files.entries.firstWhere(
        (e) => e.key.endsWith('package.json'),
        orElse: () => MapEntry('', ''),
      );
      
      if (packageJson.value.contains('react')) {
        return 'React';
      }
      
      if (packageJson.value.contains('next')) {
        return 'Next.js';
      }
      
      if (packageJson.value.contains('vue')) {
        return 'Vue.js';
      }
      
      if (packageJson.value.contains('express')) {
        return 'Node.js/Express';
      }
      
      return 'Node.js';
    }
    
    // Check for Python
    if (filenames.any((f) => f.endsWith('requirements.txt') || f.endsWith('setup.py'))) {
      return 'Python';
    }
    
    // Check for Java
    if (filenames.any((f) => f.endsWith('pom.xml') || f.endsWith('build.gradle'))) {
      return 'Java';
    }
    
    return 'Unknown';
  }
}

// Made with Bob
