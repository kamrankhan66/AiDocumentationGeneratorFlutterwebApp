import '../models/file_tree_node.dart';

class FileTreeService {
  /// Build file tree from file paths
  FileTreeNode buildFileTree(Map<String, String> files) {
    // Create root node
    final root = FileTreeNode(
      name: 'root',
      path: '',
      isDirectory: true,
      children: [],
      isExpanded: true,
    );
    
    // Get all file paths
    final paths = files.keys.toList()..sort();
    
    // Build tree structure
    for (final path in paths) {
      _addPathToTree(root, path);
    }
    
    // Sort all children
    root.sortChildren();
    
    return root;
  }
  
  /// Add a file path to the tree
  void _addPathToTree(FileTreeNode root, String path) {
    final parts = path.split('/');
    FileTreeNode currentNode = root;
    String currentPath = '';
    
    for (int i = 0; i < parts.length; i++) {
      final part = parts[i];
      if (part.isEmpty) continue;
      
      currentPath += (currentPath.isEmpty ? '' : '/') + part;
      final isLastPart = i == parts.length - 1;
      
      // Check if node already exists
      FileTreeNode? existingNode;
      for (var child in currentNode.children) {
        if (child.name == part) {
          existingNode = child;
          break;
        }
      }
      
      if (existingNode != null) {
        currentNode = existingNode;
      } else {
        // Create new node
        final newNode = FileTreeNode(
          name: part,
          path: currentPath,
          isDirectory: !isLastPart,
          children: [],
          isExpanded: false,
        );
        
        // Add to parent's children
        currentNode.children.add(newNode);
        currentNode = newNode;
      }
    }
  }
  
  /// Get all file paths from tree (flattened)
  List<String> getAllFilePaths(FileTreeNode root) {
    final List<String> paths = [];
    _collectFilePaths(root, paths);
    return paths;
  }
  
  void _collectFilePaths(FileTreeNode node, List<String> paths) {
    if (!node.isDirectory && node.path.isNotEmpty) {
      paths.add(node.path);
    }
    
    for (var child in node.children) {
      _collectFilePaths(child, paths);
    }
  }
  
  /// Search files by name or path
  List<FileTreeNode> searchFiles(FileTreeNode root, String query) {
    final List<FileTreeNode> results = [];
    final lowerQuery = query.toLowerCase();
    
    _searchInNode(root, lowerQuery, results);
    
    return results;
  }
  
  void _searchInNode(FileTreeNode node, String query, List<FileTreeNode> results) {
    if (node.name.toLowerCase().contains(query) || 
        node.path.toLowerCase().contains(query)) {
      if (!node.isDirectory && node.path.isNotEmpty) {
        results.add(node);
      }
    }
    
    for (var child in node.children) {
      _searchInNode(child, query, results);
    }
  }
  
  /// Get file count statistics
  Map<String, int> getFileStatistics(FileTreeNode root) {
    int totalFiles = 0;
    int totalDirs = 0;
    final Map<String, int> extensionCount = {};
    
    _countNodes(root, (node) {
      if (node.isDirectory) {
        totalDirs++;
      } else {
        totalFiles++;
        final ext = node.extension;
        if (ext.isNotEmpty) {
          extensionCount[ext] = (extensionCount[ext] ?? 0) + 1;
        }
      }
    });
    
    return {
      'files': totalFiles,
      'directories': totalDirs,
      ...extensionCount,
    };
  }
  
  void _countNodes(FileTreeNode node, Function(FileTreeNode) callback) {
    if (node.path.isNotEmpty) {
      callback(node);
    }
    
    for (var child in node.children) {
      _countNodes(child, callback);
    }
  }
}

// Made with Bob