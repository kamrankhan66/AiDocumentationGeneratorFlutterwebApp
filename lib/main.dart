import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/upload/presentation/screens/upload_screen.dart';

void main() {
  // Debug: Check if API key is loaded from --dart-define
  if (AppConstants.geminiApiKey.isNotEmpty) {
    print('🔑 API Key loaded: ${AppConstants.geminiApiKey.substring(0, 20)}...');
  } else {
    print('⚠️ WARNING: API Key not found! Use --dart-define=GEMINI_API_KEY=your_key');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const UploadScreen(),
    );
  }
}
