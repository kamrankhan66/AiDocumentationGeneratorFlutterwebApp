class FileTreeNode {
  final String name;
  final String path;
  final bool isDirectory;
  final List<FileTreeNode> children;
  bool isExpanded;
  
  FileTreeNode({
    required this.name,
    required this.path,
    required this.isDirectory,
    this.children = const [],
    this.isExpanded = false,
  });
  
  /// Get file extension
  String get extension {
    if (isDirectory) return '';
    final parts = name.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }
  
  /// Check if node has children
  bool get hasChildren => children.isNotEmpty;
  
  /// Get depth level in tree
  int getDepth() {
    return path.split('/').length - 1;
  }
  
  /// Sort children: directories first, then files alphabetically
  void sortChildren() {
    children.sort((a, b) {
      if (a.isDirectory && !b.isDirectory) return -1;
      if (!a.isDirectory && b.isDirectory) return 1;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    
    for (var child in children) {
      child.sortChildren();
    }
  }
  
  /// Find a node by path
  FileTreeNode? findByPath(String targetPath) {
    if (path == targetPath) return this;
    
    for (var child in children) {
      final found = child.findByPath(targetPath);
      if (found != null) return found;
    }
    
    return null;
  }
  
  /// Toggle expansion state
  void toggleExpanded() {
    isExpanded = !isExpanded;
  }
  
  /// Expand all parent nodes
  void expandParents(FileTreeNode root) {
    final pathParts = path.split('/');
    String currentPath = '';
    
    for (int i = 0; i < pathParts.length - 1; i++) {
      currentPath += (i > 0 ? '/' : '') + pathParts[i];
      final node = root.findByPath(currentPath);
      if (node != null) {
        node.isExpanded = true;
      }
    }
  }
}

// Made with Bob