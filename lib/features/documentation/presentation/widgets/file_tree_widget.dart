import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/file_icon_helper.dart';
import '../../../../models/file_tree_node.dart';

class FileTreeWidget extends StatefulWidget {
  final FileTreeNode rootNode;
  final String? selectedPath;
  final Function(FileTreeNode) onFileSelected;
  final Map<String, String> fileContents;

  const FileTreeWidget({
    super.key,
    required this.rootNode,
    required this.onFileSelected,
    required this.fileContents,
    this.selectedPath,
  });

  @override
  State<FileTreeWidget> createState() => _FileTreeWidgetState();
}

class _FileTreeWidgetState extends State<FileTreeWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withValues(alpha: 0.3),
        border: Border(
          right: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(),

          // Search bar
          _buildSearchBar(),

          // File tree
          Expanded(child: _buildFileTree()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withValues(alpha: 0.5),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.folder_open, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: 8),
          Text(
            'Project Files',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: Theme.of(context).textTheme.bodySmall,
        decoration: InputDecoration(
          hintText: 'Search files...',
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 12,
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 18,
            color: Colors.white.withValues(alpha: 0.5),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 18,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: AppTheme.surfaceColor.withValues(alpha: 0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppTheme.primaryColor, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
      ),
    );
  }

  Widget _buildFileTree() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: _buildTreeNodes(widget.rootNode.children, 0),
    );
  }

  List<Widget> _buildTreeNodes(List<FileTreeNode> nodes, int depth) {
    final List<Widget> widgets = [];

    for (final node in nodes) {
      // Filter by search query
      if (_searchQuery.isNotEmpty) {
        final matchesSearch =
            node.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            node.path.toLowerCase().contains(_searchQuery.toLowerCase());

        if (!matchesSearch && !_hasMatchingChild(node)) {
          continue;
        }
      }

      widgets.add(_buildTreeNode(node, depth));

      // Add children if expanded
      if (node.isDirectory && node.isExpanded) {
        widgets.addAll(_buildTreeNodes(node.children, depth + 1));
      }
    }

    return widgets;
  }

  bool _hasMatchingChild(FileTreeNode node) {
    if (node.name.toLowerCase().contains(_searchQuery.toLowerCase())) {
      return true;
    }

    for (final child in node.children) {
      if (_hasMatchingChild(child)) {
        return true;
      }
    }

    return false;
  }

  Widget _buildTreeNode(FileTreeNode node, int depth) {
    final isSelected = widget.selectedPath == node.path;
    final hasContent = widget.fileContents.containsKey(node.path);

    return InkWell(
      onTap: () {
        if (node.isDirectory) {
          setState(() {
            node.toggleExpanded();
          });
        } else if (hasContent) {
          widget.onFileSelected(node);
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 16.0 + (depth * 20.0),
          right: 16,
          top: 8,
          bottom: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withValues(alpha: 0.2)
              : Colors.transparent,
          border: Border(
            left: isSelected
                ? BorderSide(color: AppTheme.primaryColor, width: 3)
                : BorderSide.none,
          ),
        ),
        child: Row(
          children: [
            // Expand/collapse icon for directories
            if (node.isDirectory)
              Icon(
                node.isExpanded
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right,
                size: 16,
                color: Colors.white.withValues(alpha: 0.7),
              )
            else
              const SizedBox(width: 16),

            const SizedBox(width: 4),

            // File/folder icon
            Icon(
              node.isDirectory
                  ? FileIconHelper.getFolderIcon(node.isExpanded)
                  : FileIconHelper.getSpecialFileIcon(node.name) ??
                        FileIconHelper.getFileIcon(node.extension),
              size: 16,
              color: node.isDirectory
                  ? AppTheme.accentColor
                  : FileIconHelper.getFileColor(node.extension),
            ),

            const SizedBox(width: 8),

            // File/folder name
            Expanded(
              child: Text(
                node.name,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: !hasContent && !node.isDirectory
                      ? Colors.white.withValues(alpha: 0.4)
                      : Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Indicator for files without content
            if (!node.isDirectory && !hasContent)
              Icon(
                Icons.lock_outline,
                size: 12,
                color: Colors.white.withValues(alpha: 0.3),
              ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms);
  }
}

// Made with Bob
