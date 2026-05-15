import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:markdown/markdown.dart' as md;
import '../../../../core/theme/app_theme.dart';
import '../../../../models/project_info.dart';
import '../../../../services/gemini_service.dart';

class AiChatWidget extends StatefulWidget {
  final ProjectInfo projectInfo;
  final Map<String, String> fileContents;
  final String? initialFileName;
  final String? initialFileContent;

  const AiChatWidget({
    super.key,
    required this.projectInfo,
    required this.fileContents,
    this.initialFileName,
    this.initialFileContent,
  });

  @override
  State<AiChatWidget> createState() => AiChatWidgetState();
  
  // Static method to access state
  static AiChatWidgetState? of(BuildContext context) {
    return context.findAncestorStateOfType<AiChatWidgetState>();
  }
}

class AiChatWidgetState extends State<AiChatWidget> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GeminiService _geminiService = GeminiService();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _currentFileName;
  String? _currentFileContent;
  @override
  void initState() {
    super.initState();
    
    // Auto-explain file if provided
    if (widget.initialFileName != null && widget.initialFileContent != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _explainFile(widget.initialFileName!, widget.initialFileContent!);
      });
    }
  }


  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    if (!mounted) return;
    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      // Build conversation history
      final conversationHistory = _messages
          .where((msg) => !msg.isCodeOnly)
          .map((msg) => {
                'role': msg.isUser ? 'User' : 'AI',
                'message': msg.text,
              })
          .toList();
      
      // Use the enhanced conversational method with context
      final response = await _geminiService.answerCodebaseQuestion(
        message,
        widget.projectInfo,
        currentFileName: _currentFileName,
        currentFileContent: _currentFileContent,
        conversationHistory: conversationHistory,
      );

      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(
          text: 'Sorry, I encountered an error: ${e.toString()}',
          isUser: false,
          timestamp: DateTime.now(),
          isError: true,
        ));
        _isLoading = false;
      });
    }
  }

  Future<void> _explainFile(String filename, String content) async {
    // Update current file context
    _currentFileName = filename;
    _currentFileContent = content;
    
    // Detect language from filename
    String language = _detectLanguage(filename);
    
    if (!mounted) return;
    setState(() {
      _messages.add(ChatMessage(
        text: 'Show me the file: $filename',
        isUser: true,
        timestamp: DateTime.now(),
      ));
      
      // Add the full code as a message with code block
      _messages.add(ChatMessage(
        text: '```$language\n$content\n```',
        isUser: false,
        timestamp: DateTime.now(),
        isCodeOnly: true,
      ));
      
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final response = await _geminiService.explainFile(
        filename,
        content,
        widget.projectInfo,
      );

      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(
          text: 'Sorry, I encountered an error: ${e.toString()}',
          isUser: false,
          timestamp: DateTime.now(),
          isError: true,
        ));
        _isLoading = false;
      });
    }
  }

  String _detectLanguage(String filename) {
    final extension = filename.split('.').last.toLowerCase();
    switch (extension) {
      case 'dart':
        return 'dart';
      case 'js':
        return 'javascript';
      case 'ts':
        return 'typescript';
      case 'py':
        return 'python';
      case 'java':
        return 'java';
      case 'kt':
        return 'kotlin';
      case 'swift':
        return 'swift';
      case 'html':
        return 'html';
      case 'css':
        return 'css';
      case 'json':
        return 'json';
      case 'yaml':
      case 'yml':
        return 'yaml';
      case 'xml':
        return 'xml';
      case 'md':
        return 'markdown';
      default:
        return 'dart';
    }
  }

  void _copyMessage(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message copied to clipboard'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withValues(alpha: 0.3),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(),
          
          // Messages
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : _buildMessageList(),
          ),
          
          // Loading indicator
          if (_isLoading) _buildLoadingIndicator(),
          
          // Input field
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withValues(alpha: 0.3),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.smart_toy,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'AI Assistant',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Ask about your codebase',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (_messages.isNotEmpty)
            IconButton(
              onPressed: () {
                setState(() {
                  _messages.clear();
                });
              },
              icon: const Icon(Icons.delete_outline, size: 20),
              tooltip: 'Clear chat',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildEmptyState() {
    final suggestedQuestions = [
      'How does authentication work?',
      'Explain the app architecture',
      'Which file handles API requests?',
      'Where is state management implemented?',
      'Explain the login flow',
      'How does navigation work?',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Talk To Your Codebase',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ask me anything about your project',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Try asking:',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 16),
          ...suggestedQuestions.map((question) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => _sendMessage(question),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 20,
                      color: AppTheme.accentColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        question,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return _buildMessageBubble(_messages[index]);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    // For code-only messages, use full width
    final isFullWidth = message.isCodeOnly;
    
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(
          maxWidth: isFullWidth
              ? MediaQuery.of(context).size.width * 0.95
              : MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: message.isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: message.isUser
                    ? AppTheme.primaryGradient
                    : null,
                color: message.isUser
                    ? null
                    : message.isError
                        ? Colors.red.withValues(alpha: 0.3)
                        : AppTheme.surfaceColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: message.isUser
                    ? null
                    : Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
              ),
              child: message.isUser
                  ? Text(
                      message.text,
                      style: const TextStyle(color: Colors.white),
                    )
                  : _buildMarkdownWithCodeHighlight(message.text),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.timestamp),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.3),
                    fontSize: 10,
                  ),
                ),
                if (!message.isUser) ...[
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => _copyMessage(message.text),
                    child: Icon(
                      Icons.copy,
                      size: 12,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: message.isUser ? 0.2 : -0.2);
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              'AI is thinking...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.3),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withValues(alpha: 0.3),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              enabled: !_isLoading,
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: _isLoading ? null : _sendMessage,
              style: Theme.of(context).textTheme.bodySmall,
              decoration: InputDecoration(
                hintText: 'Ask about your codebase...',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 13,
                ),
                filled: true,
                fillColor: AppTheme.surfaceColor.withValues(alpha: 0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppTheme.primaryColor,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: _isLoading
                  ? null
                  : () => _sendMessage(_messageController.text),
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              tooltip: 'Send message',
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildMarkdownWithCodeHighlight(String text) {
    return MarkdownBody(
      data: text,
      shrinkWrap: true,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontSize: 14,
          height: 1.4,
        ),
        h1: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        h2: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        h3: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        listBullet: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppTheme.accentColor,
        ),
        code: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontFamily: 'Courier',
          backgroundColor: const Color(0xFF272822),
          color: const Color(0xFFF8F8F2),
          fontSize: 13,
        ),
        codeblockPadding: const EdgeInsets.all(12),
        codeblockDecoration: BoxDecoration(
          color: const Color(0xFF272822),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        blockquote: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.white.withValues(alpha: 0.3),
          fontStyle: FontStyle.italic,
        ),
        blockquoteDecoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(4),
          border: Border(
            left: BorderSide(
              color: AppTheme.accentColor,
              width: 3,
            ),
          ),
        ),
        tableBorder: TableBorder.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
        tableHead: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        tableBody: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.white.withValues(alpha: 0.3),
        ),
      ),
      builders: {
        'code': CodeElementBuilder(),
      },
      extensionSet: md.ExtensionSet.gitHubFlavored,
    );
  }

  // Public method to explain a file from outside
  void explainFile(String filename, String content) {
    _explainFile(filename, content);
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isError;
  final bool isCodeOnly;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isError = false,
    this.isCodeOnly = false,
  });
}

// Custom code block builder with VS Code-style syntax highlighting
class CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var language = '';

    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      language = lg.substring(9); // Remove 'language-' prefix
    }

    // Extract code content
    final code = element.textContent;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with language and copy button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
              ),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getLanguageIcon(language),
                  size: 14,
                  color: _getLanguageColor(language),
                ),
                const SizedBox(width: 8),
                Text(
                  language.isEmpty ? 'code' : language,
                  style: TextStyle(
                    color: _getLanguageColor(language),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: code));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.content_copy,
                          size: 12,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Copy',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.3),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Code content with syntax highlighting
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: HighlightView(
              code,
              language: language.isEmpty ? 'dart' : language,
              theme: monokaiSublimeTheme,
              padding: const EdgeInsets.all(14),
              textStyle: const TextStyle(
                fontFamily: 'Courier',
                fontSize: 13,
                height: 1.3,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getLanguageIcon(String language) {
    switch (language.toLowerCase()) {
      case 'dart':
        return Icons.code;
      case 'javascript':
      case 'js':
        return Icons.javascript;
      case 'python':
      case 'py':
        return Icons.code;
      case 'java':
        return Icons.coffee;
      case 'html':
        return Icons.html;
      case 'css':
        return Icons.style;
      case 'json':
        return Icons.data_object;
      case 'yaml':
      case 'yml':
        return Icons.settings;
      default:
        return Icons.code;
    }
  }

  Color _getLanguageColor(String language) {
    switch (language.toLowerCase()) {
      case 'dart':
        return const Color(0xFF0175C2);
      case 'javascript':
      case 'js':
        return const Color(0xFFF7DF1E);
      case 'python':
      case 'py':
        return const Color(0xFF3776AB);
      case 'java':
        return const Color(0xFFED8B00);
      case 'html':
        return const Color(0xFFE34C26);
      case 'css':
        return const Color(0xFF1572B6);
      case 'json':
        return const Color(0xFF00D8FF);
      case 'yaml':
      case 'yml':
        return const Color(0xFFCB171E);
      default:
        return const Color(0xFF858585);
    }
  }
}

// Made with Bob

