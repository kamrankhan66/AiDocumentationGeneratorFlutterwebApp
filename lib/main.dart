import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/upload/presentation/screens/upload_screen.dart';

Future<void> main() async {
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  // Debug: Check if API key is loaded
  print('🔑 API Key loaded: ${dotenv.env['GEMINI_API_KEY']?.substring(0, 20)}...');
  print('📁 .env file loaded successfully');
  
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
