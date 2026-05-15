import 'package:flutter/material.dart';

class FileIconHelper {
  /// Get icon for file based on extension
  static IconData getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      // Dart
      case 'dart':
        return Icons.code;
      
      // JavaScript/TypeScript
      case 'js':
      case 'jsx':
      case 'ts':
      case 'tsx':
        return Icons.javascript;
      
      // Web
      case 'html':
      case 'htm':
        return Icons.html;
      case 'css':
      case 'scss':
      case 'sass':
      case 'less':
        return Icons.css;
      
      // Config files
      case 'json':
      case 'yaml':
      case 'yml':
      case 'toml':
      case 'xml':
        return Icons.settings_applications;
      
      // Documentation
      case 'md':
      case 'markdown':
      case 'txt':
        return Icons.description;
      
      // Images
      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'gif':
      case 'svg':
      case 'webp':
      case 'ico':
        return Icons.image;
      
      // Python
      case 'py':
      case 'pyc':
      case 'pyw':
        return Icons.code;
      
      // Java/Kotlin
      case 'java':
      case 'kt':
      case 'kts':
        return Icons.code;
      
      // C/C++
      case 'c':
      case 'cpp':
      case 'h':
      case 'hpp':
        return Icons.code;
      
      // Shell scripts
      case 'sh':
      case 'bash':
      case 'zsh':
        return Icons.terminal;
      
      // Build files
      case 'gradle':
      case 'lock':
        return Icons.build;
      
      // Database
      case 'sql':
      case 'db':
      case 'sqlite':
        return Icons.storage;
      
      // Archives
      case 'zip':
      case 'tar':
      case 'gz':
      case 'rar':
        return Icons.folder_zip;
      
      default:
        return Icons.insert_drive_file;
    }
  }
  
  /// Get color for file based on extension
  static Color getFileColor(String extension) {
    switch (extension.toLowerCase()) {
      // Dart - Blue
      case 'dart':
        return const Color(0xFF0175C2);
      
      // JavaScript - Yellow
      case 'js':
      case 'jsx':
        return const Color(0xFFF7DF1E);
      
      // TypeScript - Blue
      case 'ts':
      case 'tsx':
        return const Color(0xFF3178C6);
      
      // HTML - Orange
      case 'html':
      case 'htm':
        return const Color(0xFFE34C26);
      
      // CSS - Blue
      case 'css':
      case 'scss':
      case 'sass':
        return const Color(0xFF1572B6);
      
      // JSON - Green
      case 'json':
        return const Color(0xFF5CB85C);
      
      // YAML - Red
      case 'yaml':
      case 'yml':
        return const Color(0xFFCB171E);
      
      // Markdown - Gray
      case 'md':
      case 'markdown':
        return const Color(0xFF083FA1);
      
      // Images - Purple
      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'gif':
      case 'svg':
        return const Color(0xFF9C27B0);
      
      // Python - Blue/Yellow
      case 'py':
        return const Color(0xFF3776AB);
      
      // Java - Red
      case 'java':
        return const Color(0xFFB07219);
      
      // Kotlin - Purple
      case 'kt':
      case 'kts':
        return const Color(0xFF7F52FF);
      
      default:
        return Colors.grey;
    }
  }
  
  /// Get icon for directory
  static IconData getFolderIcon(bool isExpanded) {
    return isExpanded ? Icons.folder_open : Icons.folder;
  }
  
  /// Get special icon for specific filenames
  static IconData? getSpecialFileIcon(String filename) {
    final lower = filename.toLowerCase();
    
    if (lower == 'readme.md' || lower == 'readme') {
      return Icons.info_outline;
    }
    if (lower == 'license' || lower == 'license.md') {
      return Icons.gavel;
    }
    if (lower == 'package.json') {
      return Icons.inventory_2;
    }
    if (lower == 'pubspec.yaml') {
      return Icons.inventory_2;
    }
    if (lower.contains('config')) {
      return Icons.settings;
    }
    if (lower.contains('test')) {
      return Icons.science;
    }
    if (lower == '.gitignore') {
      return Icons.block;
    }
    if (lower == 'dockerfile') {
      return Icons.sailing;
    }
    
    return null;
  }
}

// Made with Bob