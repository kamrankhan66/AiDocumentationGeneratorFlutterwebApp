class ProjectInfo {
  final String projectName;
  final String projectType; // Flutter, React, Node, etc.
  final String? description;
  final Map<String, dynamic> dependencies;
  final List<String> fileStructure;
  final Map<String, String> importantFiles; // filename -> content
  final Map<String, String> allFiles; // All extracted files (path -> content)
  final String? architecture;
  final List<String> features;
  
  ProjectInfo({
    required this.projectName,
    required this.projectType,
    this.description,
    required this.dependencies,
    required this.fileStructure,
    required this.importantFiles,
    required this.allFiles,
    this.architecture,
    required this.features,
  });
  
  Map<String, dynamic> toJson() => {
    'projectName': projectName,
    'projectType': projectType,
    'description': description,
    'dependencies': dependencies,
    'fileStructure': fileStructure,
    'importantFiles': importantFiles,
    'allFiles': allFiles,
    'architecture': architecture,
    'features': features,
  };
  
  factory ProjectInfo.fromJson(Map<String, dynamic> json) => ProjectInfo(
    projectName: json['projectName'] as String,
    projectType: json['projectType'] as String,
    description: json['description'] as String?,
    dependencies: json['dependencies'] as Map<String, dynamic>,
    fileStructure: List<String>.from(json['fileStructure'] as List),
    importantFiles: Map<String, String>.from(json['importantFiles'] as Map),
    allFiles: Map<String, String>.from(json['allFiles'] as Map? ?? {}),
    architecture: json['architecture'] as String?,
    features: List<String>.from(json['features'] as List),
  );
  
  String toContextString() {
    final buffer = StringBuffer();
    
    buffer.writeln('# Project: $projectName');
    buffer.writeln('Type: $projectType');
    if (description != null) {
      buffer.writeln('Description: $description');
    }
    if (architecture != null) {
      buffer.writeln('Architecture: $architecture');
    }
    
    buffer.writeln('\n## Dependencies:');
    dependencies.forEach((key, value) {
      buffer.writeln('- $key: $value');
    });
    
    buffer.writeln('\n## File Structure:');
    for (var file in fileStructure.take(50)) { // Limit to first 50 files
      buffer.writeln('- $file');
    }
    
    buffer.writeln('\n## Features:');
    for (var feature in features) {
      buffer.writeln('- $feature');
    }
    
    buffer.writeln('\n## Important Files Content:');
    importantFiles.forEach((filename, content) {
      buffer.writeln('\n### $filename');
      buffer.writeln('```');
      // Limit content to first 500 characters per file
      final limitedContent = content.length > 500 
          ? '${content.substring(0, 500)}...[truncated]'
          : content;
      buffer.writeln(limitedContent);
      buffer.writeln('```');
    });
    
    return buffer.toString();
  }
}

// Made with Bob
