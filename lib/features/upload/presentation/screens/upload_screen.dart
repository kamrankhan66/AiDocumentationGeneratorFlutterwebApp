import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../models/documentation.dart';
import '../../../../services/project_analyzer_service.dart';
import '../../../documentation/presentation/screens/results_screen.dart';
import '../widgets/processing_dialog.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  // Maximum file size: 50MB (reasonable for source code without build folders)
  static const int maxFileSizeBytes = 50 * 1024 * 1024;
  final ProjectAnalyzerService _analyzerService = ProjectAnalyzerService();
  bool _isProcessing = false;
  String? _selectedFileName;
  Uint8List? _selectedFileBytes;
  bool _isDarkTheme = true; // Theme toggle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _isDarkTheme
            ? AppTheme.backgroundGradient
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF5F7FA), Color(0xFFE8EAF6)],
              ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    // Hero Section
                    _buildHeroSection(context),
                    
                    // Problem Section
                    _buildProblemSection(context),
                    
                    // Solution Section
                    _buildSolutionSection(context),
                    
                    // Upload Section
                    _buildUploadSection(context),
                    
                    // AI Agents Section
                    _buildAIAgentsSection(context),
                    
                    // Features Section
                    _buildFeaturesSection(context),
                    
                    // Footer
                    _buildFooter(context),
                  ],
                ),
              ),
              
              // Theme Toggle Button
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: _isDarkTheme
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: _isDarkTheme
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.2),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _isDarkTheme = !_isDarkTheme;
                      });
                    },
                    icon: Icon(
                      _isDarkTheme ? Icons.light_mode : Icons.dark_mode,
                      color: _isDarkTheme ? Colors.white : Colors.black87,
                    ),
                    tooltip: _isDarkTheme ? 'Light Mode' : 'Dark Mode',
                  ),
                ),
              ).animate().fadeIn(delay: 1000.ms),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTextColor() => _isDarkTheme ? Colors.white : Colors.black87;
  Color _getSecondaryTextColor() => _isDarkTheme
    ? AppTheme.textSecondary
    : Colors.black54;
                
  Widget _buildHeroSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Column(
        children: [
          // Logo
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 60,
              color: Colors.white,
            ),
          ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms, duration: 400.ms),
          
          const SizedBox(height: 40),
          
          // Title
          Text(
            'AI Documentation Generator',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 48,
              color: _getTextColor(),
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 300.ms, duration: 600.ms).slideY(begin: 0.3, end: 0),
          
          const SizedBox(height: 20),
          
          // Subtitle
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Text(
              'Transform your codebase into comprehensive, professional documentation in seconds using the power of AI',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: _getSecondaryTextColor(),
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ).animate().fadeIn(delay: 500.ms, duration: 600.ms).slideY(begin: 0.3, end: 0),
          
          const SizedBox(height: 40),
          
          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatCard('5+', 'AI Agents', Icons.psychology),
              const SizedBox(width: 40),
              _buildStatCard('< 2min', 'Processing', Icons.speed),
              const SizedBox(width: 40),
              _buildStatCard('100%', 'Automated', Icons.auto_fix_high),
            ],
          ).animate().fadeIn(delay: 700.ms, duration: 600.ms),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.glassDecoration(blur: 15, opacity: 0.05),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.accentColor, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: _getTextColor(),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: _getSecondaryTextColor(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProblemSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      color: _isDarkTheme
        ? Colors.black.withValues(alpha: 0.2)
        : Colors.white.withValues(alpha: 0.5),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            // Section Title
            Text(
              '❌ The Documentation Problem',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _isDarkTheme ? AppTheme.errorColor : Colors.red.shade700,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 100.ms),
            
            const SizedBox(height: 40),
            
            // Problems Grid
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _buildProblemCard(
                  '⏰ Time-Consuming',
                  'Writing documentation manually takes hours or even days, pulling developers away from actual coding',
                  Icons.access_time,
                ),
                _buildProblemCard(
                  '📉 Outdated Quickly',
                  'Documentation becomes obsolete as code evolves, leading to confusion and errors',
                  Icons.trending_down,
                ),
                _buildProblemCard(
                  '😰 Inconsistent Quality',
                  'Different developers write docs differently, making it hard to maintain standards',
                  Icons.warning_amber,
                ),
                _buildProblemCard(
                  '🔍 Hard to Understand',
                  'New team members struggle to understand complex codebases without proper documentation',
                  Icons.search_off,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProblemCard(String title, String description, IconData icon) {
    return Container(
      width: 280,
      height: 220, // Fixed height for consistency
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _isDarkTheme
          ? AppTheme.errorColor.withValues(alpha: 0.1)
          : Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isDarkTheme
            ? AppTheme.errorColor.withValues(alpha: 0.3)
            : Colors.red.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: _isDarkTheme ? AppTheme.errorColor : Colors.red.shade700,
            size: 40
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _getTextColor(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: _getSecondaryTextColor(),
                height: 1.5,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2, end: 0);
  }

  Widget _buildSolutionSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            // Section Title
            Text(
              '✨ Our AI-Powered Solution',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _isDarkTheme ? AppTheme.successColor : Colors.green.shade700,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 100.ms),
            
            const SizedBox(height: 20),
            
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Text(
                'We leverage advanced AI technology to automatically analyze your entire codebase and generate comprehensive, professional documentation in minutes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: _getSecondaryTextColor(),
                ),
                textAlign: TextAlign.center,
              ),
            ).animate().fadeIn(delay: 200.ms),
            
            const SizedBox(height: 40),
            
            // Solution Benefits
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _buildSolutionCard(
                  '⚡ Lightning Fast',
                  'Generate complete documentation in under 2 minutes',
                  Icons.flash_on,
                  AppTheme.successColor,
                ),
                _buildSolutionCard(
                  '🎯 Always Accurate',
                  'AI analyzes actual code, ensuring documentation matches reality',
                  Icons.check_circle,
                  AppTheme.primaryColor,
                ),
                _buildSolutionCard(
                  '📚 Comprehensive',
                  'Covers README, architecture, APIs, flows, and suggestions',
                  Icons.library_books,
                  AppTheme.accentColor,
                ),
                _buildSolutionCard(
                  '💬 Interactive',
                  'Chat with AI to understand any part of your codebase',
                  Icons.chat_bubble,
                  Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolutionCard(String title, String description, IconData icon, Color color) {
    final cardColor = _isDarkTheme ? color : color.withValues(alpha: 0.8);
    return Container(
      width: 280,
      height: 220, // Fixed height for consistency
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _isDarkTheme
          ? color.withValues(alpha: 0.1)
          : color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isDarkTheme
            ? color.withValues(alpha: 0.3)
            : color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: cardColor, size: 40),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _getTextColor(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: _getSecondaryTextColor(),
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.2, end: 0);
  }

  Widget _buildUploadSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      color: _isDarkTheme
        ? Colors.black.withValues(alpha: 0.2)
        : Colors.white.withValues(alpha: 0.5),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Column(
          children: [
            Text(
              '🚀 Get Started Now',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getTextColor(),
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 100.ms),
            
            const SizedBox(height: 40),
            
            _buildUploadArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildAIAgentsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            Text(
              '🤖 Meet Our AI Agents',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getTextColor(),
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 100.ms),
            
            const SizedBox(height: 20),
            
            Text(
              'Five specialized AI agents work together to analyze and document your codebase',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: _getSecondaryTextColor(),
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 200.ms),
            
            const SizedBox(height: 40),
            
            // Agents
            Column(
              children: [
                _buildAgentCard(
                  '1️⃣ README Agent',
                  'Creates comprehensive project overview',
                  'Analyzes project structure, dependencies, and features to generate a professional README.md with installation instructions, usage guide, and project description',
                  Icons.description,
                  AppTheme.primaryColor,
                  ['Project Overview', 'Setup Instructions', 'Features List', 'Usage Examples'],
                ),
                const SizedBox(height: 20),
                _buildAgentCard(
                  '2️⃣ Architecture Agent',
                  'Documents system design and structure',
                  'Examines code organization, design patterns, and architectural decisions to create detailed architecture documentation explaining how components interact',
                  Icons.architecture,
                  Colors.orange,
                  ['Layer Analysis', 'Design Patterns', 'Component Structure', 'Data Flow'],
                ),
                const SizedBox(height: 20),
                _buildAgentCard(
                  '3️⃣ API Agent',
                  'Generates complete API documentation',
                  'Scans all API endpoints, services, and data models to produce comprehensive API documentation with request/response formats and authentication details',
                  Icons.api,
                  Colors.green,
                  ['Endpoints List', 'Request/Response', 'Authentication', 'Error Codes'],
                ),
                const SizedBox(height: 20),
                _buildAgentCard(
                  '4️⃣ Flow Agent',
                  'Explains application workflows',
                  'Traces user journeys and data flows through the application to document key processes, state management, and navigation patterns',
                  Icons.account_tree,
                  Colors.blue,
                  ['User Flows', 'State Management', 'Navigation', 'Data Processing'],
                ),
                const SizedBox(height: 20),
                _buildAgentCard(
                  '5️⃣ Suggestion Agent',
                  'Provides improvement recommendations',
                  'Reviews code quality, performance, security, and best practices to suggest actionable improvements and optimizations for your codebase',
                  Icons.lightbulb,
                  Colors.amber,
                  ['Code Quality', 'Performance Tips', 'Security Fixes', 'Best Practices'],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgentCard(
    String title,
    String subtitle,
    String description,
    IconData icon,
    Color color,
    List<String> features,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _isDarkTheme
          ? color.withValues(alpha: 0.1)
          : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isDarkTheme
            ? color.withValues(alpha: 0.3)
            : color.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: _isDarkTheme ? null : [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.6)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 40),
          ),
          
          const SizedBox(width: 24),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _getTextColor(),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: _isDarkTheme ? color : color.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: _getSecondaryTextColor(),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: features.map((feature) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _isDarkTheme
                        ? color.withValues(alpha: 0.2)
                        : color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _isDarkTheme
                          ? color.withValues(alpha: 0.4)
                          : color.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      feature,
                      style: TextStyle(
                        fontSize: 12,
                        color: _getTextColor(),
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildFeaturesSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      color: _isDarkTheme
        ? Colors.black.withValues(alpha: 0.2)
        : Colors.white.withValues(alpha: 0.5),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            Text(
              '✨ Key Features',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getTextColor(),
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 100.ms),
            
            const SizedBox(height: 40),
            
            _buildFeatures(),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Text(
            'Built with ❤️ using IBM BOB AI',
            style: TextStyle(
              color: _getSecondaryTextColor(),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Powered by Flutter & Google Gemini AI',
            style: TextStyle(
              color: _getSecondaryTextColor(),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatures() {
    final features = [
      {
        'icon': Icons.description_outlined,
        'title': 'README Generation',
        'description': 'Professional README with setup guide',
      },
      {
        'icon': Icons.architecture_outlined,
        'title': 'Architecture Analysis',
        'description': 'Detailed architecture explanation',
      },
      {
        'icon': Icons.api_outlined,
        'title': 'API Documentation',
        'description': 'Complete API endpoint docs',
      },
      {
        'icon': Icons.lightbulb_outline,
        'title': 'Improvement Tips',
        'description': 'AI-powered suggestions',
      },
    ];

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      alignment: WrapAlignment.center,
      children: features.asMap().entries.map((entry) {
        final index = entry.key;
        final feature = entry.value;

        return Container(
              width: 180,
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.glassDecoration(blur: 15, opacity: 0.05),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      feature['icon'] as IconData,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    feature['title'] as String,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    feature['description'] as String,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
            .animate()
            .fadeIn(delay: (900 + index * 100).ms, duration: 600.ms)
            .slideY(begin: 0.3, end: 0);
      }).toList(),
    );
  }

  Widget _buildUploadArea() {
    return Container(
          decoration: AppTheme.glassDecoration(blur: 20, opacity: 0.05),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.5),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(60),
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 80,
                    color: AppTheme.primaryColor.withValues(alpha: 0.7),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Drop your ZIP file here',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text('or', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _pickFile,
                    icon: const Icon(Icons.folder_open),
                    label: const Text('Browse Files'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Maximum size: 50MB • Supports: Flutter, React, Node.js',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.warningColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.warningColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: AppTheme.warningColor,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Exclude build/, node_modules/, .git/ from ZIP',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppTheme.warningColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 700.ms, duration: 600.ms)
        .scale(delay: 700.ms, duration: 400.ms);
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        // Validate file size
        if (file.size > maxFileSizeBytes) {
          _showError(
            'File too large!\n\n'
            'Maximum size: 50MB\n'
            'Your file: ${(file.size / (1024 * 1024)).toStringAsFixed(1)}MB\n\n'
            'Please ensure your ZIP doesn\'t include:\n'
            '• build/ folders\n'
            '• node_modules/\n'
            '• .git/ folder\n'
            '• Large binary files',
          );
          return;
        }

        if (file.bytes != null) {
          setState(() {
            _selectedFileName = file.name;
            _selectedFileBytes = file.bytes;
          });

          // Automatically start processing
          await _processFile();
        } else {
          _showError('Could not read file data. Please try again.');
        }
      }
    } catch (e) {
      _showError('Failed to pick file: $e');
    }
  }

  Future<void> _processFile() async {
    if (_selectedFileBytes == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Show processing dialog
      if (!mounted) return;

      AnalysisResult? result;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ProcessingDialog(
          onProcess: (onProgress) async {
            result = await _analyzerService.analyzeProject(
              _selectedFileBytes!,
              onProgress,
            );
          },
        ),
      );

      if (!mounted) return;

      if (result != null && result!.isSuccess) {
        // Navigate to results screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ResultsScreen(
              projectInfo: result!.projectInfo!,
              documentation: result!.documentation!,
            ),
          ),
        );
      } else {
        _showError(result?.message ?? 'Failed to analyze project');
      }
    } catch (e) {
      _showError('Error processing file: $e');
    } finally {
      setState(() {
        _isProcessing = false;
        _selectedFileName = null;
        _selectedFileBytes = null;
      });
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Row(
          children: [
            Icon(Icons.error_outline, color: AppTheme.errorColor),
            const SizedBox(width: 12),
            const Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Made with Bob
