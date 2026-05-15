import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../models/documentation.dart';
import '../../../../models/file_tree_node.dart';
import '../../../../models/project_info.dart';
import '../../../../services/file_tree_service.dart';
import '../widgets/ai_chat_widget.dart';
import '../widgets/file_tree_widget.dart';

class ResultsScreen extends StatefulWidget {
  final ProjectInfo projectInfo;
  final Documentation documentation;

  const ResultsScreen({
    super.key,
    required this.projectInfo,
    required this.documentation,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late FileTreeNode _fileTreeRoot;
  final FileTreeService _fileTreeService = FileTreeService();
  String? _selectedFilePath;
  String? _selectedFileName;
  String? _selectedFileContent;
  double _fileTreeWidth = 300;
  final GlobalKey<AiChatWidgetState> _chatKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _fileTreeRoot = _fileTreeService.buildFileTree(widget.projectInfo.allFiles);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  void _onFileSelected(FileTreeNode node) {
    final content = widget.projectInfo.allFiles[node.path];
    if (content != null) {
      setState(() {
        _selectedFilePath = node.path;
        _selectedFileName = node.name;
        _selectedFileContent = content;
      });
      
      // Switch to Explorer tab
      _tabController.animateTo(5);
      
      // Trigger file explanation in chat (without resetting chat)
      Future.delayed(const Duration(milliseconds: 100), () {
        _chatKey.currentState?.explainFile(node.name, content);
      });
    }
  }

  void _copyToClipboard(String content, String label) {
    Clipboard.setData(ClipboardData(text: content));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              
              // Tab Bar
              _buildTabBar(),
              
              // Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTabContent(widget.documentation.readme, 'README.md'),
                    _buildTabContent(widget.documentation.architecture, 'ARCHITECTURE.md'),
                    _buildTabContent(widget.documentation.apiDocs, 'API_DOCS.md'),
                    _buildTabContent(widget.documentation.flowExplanation, 'FLOW.md'),
                    _buildTabContent(widget.documentation.suggestions, 'SUGGESTIONS.md'),
                    _buildExplorerTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withValues(alpha:0.5),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha:0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Back',
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.projectInfo.projectType,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (widget.projectInfo.architecture != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor.withValues(alpha:0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.accentColor),
                        ),
                        child: Text(
                          widget.projectInfo.architecture!,
                          style: const TextStyle(
                            color: AppTheme.accentColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.projectInfo.projectName,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 20),
          ).animate().scale(duration: 400.ms),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withValues(alpha:0.3),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha:0.1),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        tabs: const [
          Tab(icon: Icon(Icons.description_outlined, size: 18), text: 'README'),
          Tab(icon: Icon(Icons.architecture_outlined, size: 18), text: 'Architecture'),
          Tab(icon: Icon(Icons.api_outlined, size: 18), text: 'API Docs'),
          Tab(icon: Icon(Icons.account_tree_outlined, size: 18), text: 'Flow'),
          Tab(icon: Icon(Icons.lightbulb_outline, size: 18), text: 'Suggestions'),
          Tab(icon: Icon(Icons.explore_outlined, size: 18), text: 'Explorer'),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildTabContent(String content, String filename) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 900;
        
        return Row(
          children: [
            // Main Content - Always scrollable
            Expanded(
              flex: isWideScreen ? 3 : 1,
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: AppTheme.cardDecoration(),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor.withValues(alpha:0.5),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.insert_drive_file_outlined, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              filename,
                              style: Theme.of(context).textTheme.titleSmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _copyToClipboard(content, filename),
                            icon: const Icon(Icons.copy, size: 18),
                            tooltip: 'Copy',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                    // Scrollable Markdown Content
                    Expanded(
                      child: Markdown(
                        data: content,
                        selectable: true,
                        padding: const EdgeInsets.all(16),
                        styleSheet: MarkdownStyleSheet(
                          h1: Theme.of(context).textTheme.headlineMedium,
                          h2: Theme.of(context).textTheme.headlineSmall,
                          h3: Theme.of(context).textTheme.titleLarge,
                          p: Theme.of(context).textTheme.bodyMedium,
                          code: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                            backgroundColor: AppTheme.surfaceColor,
                          ),
                          codeblockDecoration: BoxDecoration(
                            color: AppTheme.surfaceColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
            ),
            
            // Sidebar - Only on wide screens
            if (isWideScreen)
              SizedBox(
                width: 280,
                child: Container(
                  margin: const EdgeInsets.only(top: 16, right: 16, bottom: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Stats Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: AppTheme.cardDecoration(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Project Stats',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 12),
                              _buildStatRow(
                                Icons.folder_outlined,
                                'Files',
                                widget.projectInfo.fileStructure.length.toString(),
                              ),
                              const SizedBox(height: 8),
                              _buildStatRow(
                                Icons.extension_outlined,
                                'Dependencies',
                                widget.projectInfo.dependencies.length.toString(),
                              ),
                              const SizedBox(height: 8),
                              _buildStatRow(
                                Icons.star_outline,
                                'Features',
                                widget.projectInfo.features.length.toString(),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
                        
                        const SizedBox(height: 16),
                        
                        // Features Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: AppTheme.cardDecoration(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Features',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 12),
                              ...widget.projectInfo.features.take(8).map(
                                (feature) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        size: 14,
                                        color: AppTheme.successColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          feature,
                                          style: Theme.of(context).textTheme.bodySmall,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.primaryColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildExplorerTab() {
    return Row(
      children: [
        // File Tree - Left Side (Resizable)
        SizedBox(
          width: _fileTreeWidth,
          child: FileTreeWidget(
            rootNode: _fileTreeRoot,
            selectedPath: _selectedFilePath,
            onFileSelected: _onFileSelected,
            fileContents: widget.projectInfo.allFiles,
          ),
        ),
        
        // Resizer for File Tree
        MouseRegion(
          cursor: SystemMouseCursors.resizeColumn,
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                _fileTreeWidth = (_fileTreeWidth + details.delta.dx).clamp(200.0, 500.0);
              });
            },
            child: Container(
              width: 4,
              color: Colors.white.withValues(alpha:0.1),
              child: Center(
                child: Container(
                  width: 2,
                  color: AppTheme.primaryColor.withValues(alpha:0.5),
                ),
              ),
            ),
          ),
        ),
        
        // Right Side - AI Chat Only (persistent, doesn't reset)
        Expanded(
          child: AiChatWidget(
            key: _chatKey,
            projectInfo: widget.projectInfo,
            fileContents: widget.projectInfo.allFiles,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }
}

// Made with Bob
