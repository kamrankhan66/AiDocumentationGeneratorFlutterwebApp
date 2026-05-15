# AI Documentation Generator - Complete API Documentation

## Overview
This document provides comprehensive details of all APIs used in the AI Documentation Generator project.

---

## 1. Google Gemini AI API

### Base Configuration
```dart
Base URL: https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent
API Key: Required (Set in app_constants.dart)
```

### API Endpoint Details

#### Endpoint: Generate Content
**URL:** `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key={API_KEY}`

**Method:** `POST`

**Headers:**
```json
{
  "Content-Type": "application/json"
}
```

**Request Body Structure:**
```json
{
  "contents": [
    {
      "parts": [
        {
          "text": "Your prompt here"
        }
      ]
    }
  ],
  "generationConfig": {
    "temperature": 0.7,
    "topK": 40,
    "topP": 0.95,
    "maxOutputTokens": 8192
  }
}
```

**Response Structure:**
```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "Generated response text here"
          }
        ],
        "role": "model"
      },
      "finishReason": "STOP",
      "index": 0,
      "safetyRatings": [
        {
          "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
          "probability": "NEGLIGIBLE"
        }
      ]
    }
  ],
  "promptFeedback": {
    "safetyRatings": [
      {
        "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
        "probability": "NEGLIGIBLE"
      }
    ]
  }
}
```

---

## 2. API Usage in Project

### 2.1 Generate README Documentation

**Function:** `generateReadme(ProjectInfo projectInfo)`

**API Call:**
```dart
POST https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key={API_KEY}
```

**Request Body Example:**
```json
{
  "contents": [
    {
      "parts": [
        {
          "text": "You are an expert technical writer...\n\nGenerate a comprehensive README.md for this project:\n\nProject Name: MyApp\nType: Flutter\nArchitecture: Clean Architecture\nFeatures: Authentication, API Integration, State Management\n\nCreate a professional README with:\n1. Project title and description\n2. Features list\n3. Installation instructions\n4. Usage guide\n5. Project structure\n6. Technologies used\n7. Contributing guidelines"
        }
      ]
    }
  ],
  "generationConfig": {
    "temperature": 0.7,
    "topK": 40,
    "topP": 0.95,
    "maxOutputTokens": 8192
  }
}
```

**Response Example:**
```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "# MyApp\n\n## Description\nA modern Flutter application...\n\n## Features\n- User Authentication\n- API Integration\n- State Management\n\n## Installation\n```bash\nflutter pub get\nflutter run\n```\n..."
          }
        ]
      }
    }
  ]
}
```

---

### 2.2 Generate Architecture Documentation

**Function:** `generateArchitectureDoc(ProjectInfo projectInfo)`

**API Call:**
```dart
POST https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key={API_KEY}
```

**Request Body Example:**
```json
{
  "contents": [
    {
      "parts": [
        {
          "text": "You are an expert software architect...\n\nAnalyze and document the architecture:\n\nProject: MyApp\nType: Flutter\nArchitecture: Clean Architecture\nLayers: Presentation, Domain, Data\nFile Structure:\n- lib/features/\n- lib/core/\n- lib/models/\n\nProvide:\n1. Architecture overview\n2. Layer descriptions\n3. Design patterns used\n4. Data flow\n5. Dependency management"
        }
      ]
    }
  ],
  "generationConfig": {
    "temperature": 0.7,
    "topK": 40,
    "topP": 0.95,
    "maxOutputTokens": 8192
  }
}
```

**Response Example:**
```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "# Architecture Documentation\n\n## Overview\nThis project follows Clean Architecture principles...\n\n## Layers\n\n### Presentation Layer\n- Handles UI and user interactions\n- Uses BLoC/Provider for state management\n\n### Domain Layer\n- Contains business logic\n- Defines use cases and entities\n\n### Data Layer\n- Manages data sources\n- Implements repositories\n..."
          }
        ]
      }
    }
  ]
}
```

---

### 2.3 Generate API Documentation

**Function:** `generateApiDoc(ProjectInfo projectInfo)`

**API Call:**
```dart
POST https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key={API_KEY}
```

**Request Body Example:**
```json
{
  "contents": [
    {
      "parts": [
        {
          "text": "You are an expert API documentation writer...\n\nDocument all APIs in this project:\n\nProject: MyApp\nAPI Services:\n- AuthService\n- UserService\n- DataService\n\nProvide:\n1. API endpoints list\n2. Request/Response formats\n3. Authentication methods\n4. Error handling\n5. Rate limits\n6. Example requests"
        }
      ]
    }
  ],
  "generationConfig": {
    "temperature": 0.7,
    "topK": 40,
    "topP": 0.95,
    "maxOutputTokens": 8192
  }
}
```

**Response Example:**
```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "# API Documentation\n\n## Authentication API\n\n### Login\n**Endpoint:** POST /api/auth/login\n**Request:**\n```json\n{\n  \"email\": \"user@example.com\",\n  \"password\": \"password123\"\n}\n```\n**Response:**\n```json\n{\n  \"token\": \"jwt_token_here\",\n  \"user\": {...}\n}\n```\n..."
          }
        ]
      }
    }
  ]
}
```

---

### 2.4 Generate Flow Explanation

**Function:** `generateFlowExplanation(ProjectInfo projectInfo)`

**API Call:**
```dart
POST https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key={API_KEY}
```

**Request Body Example:**
```json
{
  "contents": [
    {
      "parts": [
        {
          "text": "You are an expert in explaining software flows...\n\nExplain the key flows in this project:\n\nProject: MyApp\nKey Features:\n- User Authentication\n- Data Synchronization\n- Offline Support\n\nProvide:\n1. User authentication flow\n2. Data flow diagrams\n3. State management flow\n4. Error handling flow\n5. Navigation flow"
        }
      ]
    }
  ],
  "generationConfig": {
    "temperature": 0.7,
    "topK": 40,
    "topP": 0.95,
    "maxOutputTokens": 8192
  }
}
```

**Response Example:**
```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "# Flow Documentation\n\n## Authentication Flow\n\n1. User enters credentials\n2. App validates input\n3. Sends request to auth API\n4. Receives JWT token\n5. Stores token securely\n6. Navigates to home screen\n\n```\nUser Input → Validation → API Call → Token Storage → Navigation\n```\n..."
          }
        ]
      }
    }
  ]
}
```

---

### 2.5 Generate Suggestions

**Function:** `generateSuggestions(ProjectInfo projectInfo)`

**API Call:**
```dart
POST https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key={API_KEY}
```

**Request Body Example:**
```json
{
  "contents": [
    {
      "parts": [
        {
          "text": "You are an expert code reviewer...\n\nAnalyze this project and provide improvement suggestions:\n\nProject: MyApp\nCurrent State:\n- Flutter 3.x\n- Clean Architecture\n- Basic error handling\n\nProvide:\n1. Code quality improvements\n2. Performance optimizations\n3. Security enhancements\n4. Best practices\n5. Testing recommendations\n6. Documentation improvements"
        }
      ]
    }
  ],
  "generationConfig": {
    "temperature": 0.7,
    "topK": 40,
    "topP": 0.95,
    "maxOutputTokens": 8192
  }
}
```

**Response Example:**
```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "# Improvement Suggestions\n\n## Code Quality\n\n### 1. Error Handling\n- Implement global error handler\n- Add try-catch blocks\n- Use Result pattern\n\n### 2. Performance\n- Implement lazy loading\n- Optimize image loading\n- Use const constructors\n\n### 3. Security\n- Implement certificate pinning\n- Encrypt sensitive data\n- Add biometric authentication\n..."
          }
        ]
      }
    }
  ]
}
```

---

### 2.6 Explain File

**Function:** `explainFile(String filename, String content, ProjectInfo projectInfo)`

**API Call:**
```dart
POST https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key={API_KEY}
```

**Request Body Example:**
```json
{
  "contents": [
    {
      "parts": [
        {
          "text": "You are an expert technical writer...\n\nExplain this file in detail:\n\nFilename: main.dart\nProject Context: MyApp (Flutter)\n\nFile Content:\n```dart\nimport 'package:flutter/material.dart';\n\nvoid main() {\n  runApp(MyApp());\n}\n\nclass MyApp extends StatelessWidget {\n  @override\n  Widget build(BuildContext context) {\n    return MaterialApp(\n      title: 'My App',\n      home: HomeScreen(),\n    );\n  }\n}\n```\n\nProvide:\n1. Purpose of this file\n2. Key functionality\n3. How it fits in the project architecture\n4. Dependencies and relationships\n5. Potential improvements"
        }
      ]
    }
  ],
  "generationConfig": {
    "temperature": 0.7,
    "topK": 40,
    "topP": 0.95,
    "maxOutputTokens": 8192
  }
}
```

**Response Example:**
```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "# File Explanation: main.dart\n\n## Purpose\nThis is the entry point of the Flutter application...\n\n## Key Functionality\n1. **main() function**: Initializes the app\n2. **MyApp widget**: Root widget of the application\n3. **MaterialApp**: Provides Material Design\n\n## Architecture Role\n- Entry point for the entire application\n- Sets up the widget tree\n- Configures app-wide settings\n\n## Dependencies\n- flutter/material.dart: Material Design components\n- HomeScreen: Main screen widget\n\n## Improvements\n1. Add error boundary\n2. Implement dependency injection\n3. Add app initialization logic\n..."
          }
        ]
      }
    }
  ]
}
```

---

### 2.7 Answer Codebase Question (Conversational)

**Function:** `answerCodebaseQuestion(String question, ProjectInfo projectInfo, ...)`

**API Call:**
```dart
POST https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key={API_KEY}
```

**Request Body Example:**
```json
{
  "contents": [
    {
      "parts": [
        {
          "text": "You are an expert software engineer...\n\nProject Information:\n- Name: MyApp\n- Type: Flutter\n- Architecture: Clean Architecture\n- Features: Auth, API, State Management\n\nCurrently Viewing File: auth_service.dart\nFile Content:\n```dart\nclass AuthService {\n  Future<User> login(String email, String password) async {\n    // implementation\n  }\n}\n```\n\nPrevious Conversation:\nUser: What does this file do?\nAI: This file handles authentication...\n\nDeveloper Question: What is the usage of this class?\n\nProvide a detailed, helpful answer that:\n1. Directly addresses the question in context\n2. References the current file\n3. Explains the implementation\n4. Provides code examples\n5. Maintains conversation continuity"
        }
      ]
    }
  ],
  "generationConfig": {
    "temperature": 0.7,
    "topK": 40,
    "topP": 0.95,
    "maxOutputTokens": 8192
  }
}
```

**Response Example:**
```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "The `AuthService` class you're viewing is used throughout the application for user authentication. Here's how it's typically used:\n\n## Usage Examples\n\n### 1. Login Flow\n```dart\nfinal authService = AuthService();\ntry {\n  final user = await authService.login(\n    'user@example.com',\n    'password123'\n  );\n  // Navigate to home screen\n} catch (e) {\n  // Handle error\n}\n```\n\n### 2. In BLoC/Provider\n```dart\nclass AuthBloc {\n  final AuthService _authService;\n  \n  Future<void> loginUser(String email, String password) async {\n    final user = await _authService.login(email, password);\n    // Update state\n  }\n}\n```\n\n## Where It's Used\n- LoginScreen: For user login\n- AuthBloc: State management\n- ApiService: Token management\n\nThe class is a core component of your authentication system!"
          }
        ]
      }
    }
  ]
}
```

---

## 3. API Configuration

### Location
```
File: lib/core/constants/app_constants.dart
```

### Configuration Code
```dart
class AppConstants {
  // Gemini API Configuration
  static const String geminiApiUrl = 
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent';
  
  static const String geminiApiKey = 'YOUR_API_KEY_HERE';
  
  // Generation Config
  static const double temperature = 0.7;
  static const int topK = 40;
  static const double topP = 0.95;
  static const int maxOutputTokens = 8192;
}
```

---

## 4. Error Handling

### Common Error Responses

#### 400 Bad Request
```json
{
  "error": {
    "code": 400,
    "message": "Invalid request",
    "status": "INVALID_ARGUMENT"
  }
}
```

#### 401 Unauthorized
```json
{
  "error": {
    "code": 401,
    "message": "API key not valid",
    "status": "UNAUTHENTICATED"
  }
}
```

#### 429 Too Many Requests
```json
{
  "error": {
    "code": 429,
    "message": "Resource exhausted",
    "status": "RESOURCE_EXHAUSTED"
  }
}
```

#### 500 Internal Server Error
```json
{
  "error": {
    "code": 500,
    "message": "Internal error",
    "status": "INTERNAL"
  }
}
```

---

## 5. Rate Limits

### Gemini API Limits
- **Free Tier:**
  - 60 requests per minute
  - 1,500 requests per day
  
- **Paid Tier:**
  - Higher limits based on plan
  - Contact Google Cloud for details

---

## 6. Best Practices

### 1. API Key Security
```dart
// ❌ Don't hardcode API keys
const apiKey = 'AIzaSy...';

// ✅ Use environment variables
const apiKey = String.fromEnvironment('GEMINI_API_KEY');
```

### 2. Error Handling
```dart
try {
  final response = await _generateContent(prompt);
  return response;
} catch (e) {
  if (e.toString().contains('401')) {
    throw Exception('Invalid API key');
  } else if (e.toString().contains('429')) {
    throw Exception('Rate limit exceeded');
  } else {
    throw Exception('API error: $e');
  }
}
```

### 3. Request Optimization
```dart
// Use appropriate token limits
'maxOutputTokens': min(8192, estimatedTokens * 1.5)

// Adjust temperature for consistency
'temperature': 0.7  // Balanced creativity and consistency
```

---

## 7. Testing APIs

### Using Postman

**Request:**
```
POST https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=YOUR_API_KEY

Headers:
Content-Type: application/json

Body:
{
  "contents": [{
    "parts": [{
      "text": "Explain what is Flutter?"
    }]
  }],
  "generationConfig": {
    "temperature": 0.7,
    "topK": 40,
    "topP": 0.95,
    "maxOutputTokens": 1024
  }
}
```

### Using cURL

```bash
curl -X POST \
  'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=YOUR_API_KEY' \
  -H 'Content-Type: application/json' \
  -d '{
    "contents": [{
      "parts": [{
        "text": "Explain what is Flutter?"
      }]
    }],
    "generationConfig": {
      "temperature": 0.7,
      "topK": 40,
      "topP": 0.95,
      "maxOutputTokens": 1024
    }
  }'
```

---

## 8. API Response Processing

### Code Implementation
```dart
Future<String> _generateContent(String prompt) async {
  try {
    final url = Uri.parse('$_baseUrl?key=$_apiKey');
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [{'text': prompt}]
          }
        ],
        'generationConfig': {
          'temperature': 0.7,
          'topK': 40,
          'topP': 0.95,
          'maxOutputTokens': 8192,
        }
      }),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['candidates'][0]['content']['parts'][0]['text'];
      return text;
    } else {
      throw Exception('API Error: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error calling Gemini API: $e');
  }
}
```

---

## 9. Summary

### Total APIs Used: 1
- **Google Gemini AI API** (Multiple endpoints/functions)

### API Functions: 7
1. Generate README
2. Generate Architecture Documentation
3. Generate API Documentation
4. Generate Flow Explanation
5. Generate Suggestions
6. Explain File
7. Answer Codebase Questions (Conversational)

### Key Features:
- ✅ Single API with multiple use cases
- ✅ Consistent request/response format
- ✅ Comprehensive error handling
- ✅ Rate limiting support
- ✅ Conversation context support
- ✅ File-specific analysis
- ✅ Project-wide documentation generation

---

**Last Updated:** 2024
**API Version:** Gemini 1.5 Flash (Latest)
**Documentation Status:** Complete ✅