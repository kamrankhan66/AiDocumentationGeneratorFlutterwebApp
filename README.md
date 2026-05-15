# 🤖 AI Documentation Generator

An intelligent Flutter application that automatically generates comprehensive documentation for any codebase using Google Gemini AI. Built with **IBM BOB AI**.

![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Features

- 🚀 **Automatic Documentation Generation** - Upload any project and get instant documentation
- 🤖 **5 Specialized AI Agents**:
  - 📋 README Generator
  - 🏗️ Architecture Analyzer
  - 📡 API Documentation Creator
  - 🔄 Flow Explainer
  - 💡 Improvement Suggester
- 💬 **Interactive AI Chat** - Ask questions about your codebase
- 🎨 **VS Code-Style Syntax Highlighting** - Beautiful code display with Monokai theme
- 🌓 **Dark/Light Theme Toggle** - Modern responsive UI
- 🌳 **File Tree Explorer** - Navigate through project structure
- 🔍 **Smart Code Analysis** - Understands multiple programming languages

## 🛠️ Tech Stack

- **Framework**: Flutter 3.9.2
- **Language**: Dart 3.9.2
- **AI**: Google Gemini 2.5 Flash Lite
- **Syntax Highlighting**: flutter_highlight with Monokai Sublime theme
- **UI**: Material Design 3 with custom theming
- **State Management**: StatefulWidget
- **HTTP Client**: http package
- **File Handling**: file_picker, archive

## 📋 Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart SDK 3.9.2 or higher
- Google Gemini API Key ([Get it here](https://makersuite.google.com/app/apikey))
- Git

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/kamrankhan66/AI-Documentation-Generator.git
cd AI-Documentation-Generator
```

### 2. Setup Environment Variables

Create a `.env` file in the root directory:

```bash
cp .env.example .env
```

Edit `.env` and add your Gemini API key:

```env
GEMINI_API_KEY=your_actual_api_key_here
```

⚠️ **IMPORTANT**: Never commit the `.env` file to Git!

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run the Application

```bash
# For Web
flutter run -d chrome

# For Windows
flutter run -d windows

# For macOS
flutter run -d macos

# For Android
flutter run -d android

# For iOS
flutter run -d ios
```

## 📖 Usage

1. **Launch the App** - Open the application
2. **Upload Project** - Click "Choose Project Folder" and select your codebase
3. **AI Processing** - Watch as 5 AI agents analyze your project
4. **Explore Documentation** - View generated docs in organized sections
5. **Interactive Chat** - Ask questions about your code
6. **Export** - Copy or download the documentation

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart      # App configuration
│   ├── theme/
│   │   └── app_theme.dart          # Theme definitions
│   └── utils/
│       └── file_icon_helper.dart   # File type icons
├── features/
│   ├── upload/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   └── upload_screen.dart
│   │   │   └── widgets/
│   │   │       └── processing_dialog.dart
│   └── documentation/
│       └── presentation/
│           ├── screens/
│           │   └── results_screen.dart
│           └── widgets/
│               ├── ai_chat_widget.dart
│               ├── code_viewer_widget.dart
│               └── file_tree_widget.dart
├── models/
│   ├── documentation.dart          # Documentation model
│   ├── file_tree_node.dart        # File tree structure
│   └── project_info.dart          # Project metadata
├── services/
│   ├── gemini_service.dart        # AI integration
│   ├── project_analyzer_service.dart
│   ├── file_tree_service.dart
│   └── file_extraction_service.dart
└── main.dart                       # App entry point
```

## 🔐 Security

This project uses environment variables to protect sensitive API keys. See [SECURITY_FIX_GUIDE.md](SECURITY_FIX_GUIDE.md) for detailed security information.

### Best Practices:
- ✅ Store API keys in `.env` file
- ✅ Add `.env` to `.gitignore`
- ✅ Use `.env.example` as template
- ❌ Never hardcode API keys
- ❌ Never commit `.env` to Git

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 API Documentation

For detailed API documentation, see [API_DOCUMENTATION.md](API_DOCUMENTATION.md).

## 🐛 Known Issues

- Large projects (>100 files) may take longer to process
- Some binary files are automatically excluded
- API rate limits apply (check Google Gemini quotas)

## 🔮 Future Enhancements

- [ ] Support for more AI models (Claude, GPT-4, etc.)
- [ ] Export to PDF/Word formats
- [ ] GitHub integration for direct repo analysis
- [ ] Custom documentation templates
- [ ] Multi-language support
- [ ] Offline mode with cached responses
- [ ] Team collaboration features

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Kamran Khan**
- GitHub: [@kamrankhan66](https://github.com/kamrankhan66)
- Repository: [AI-Documentation-Generator](https://github.com/kamrankhan66/AI-Documentation-Generator)

## 🙏 Acknowledgments

- Built with **IBM BOB AI**
- Powered by Google Gemini AI
- Inspired by the need for better code documentation
- Thanks to the Flutter community

## 📞 Support

If you encounter any issues or have questions:

1. Check [SECURITY_FIX_GUIDE.md](SECURITY_FIX_GUIDE.md) for setup issues
2. Review [API_DOCUMENTATION.md](API_DOCUMENTATION.md) for API details
3. Open an issue on GitHub
4. Contact: [Create an issue](https://github.com/kamrankhan66/AI-Documentation-Generator/issues)

---

**Made with ❤️ using IBM BOB AI**

⭐ Star this repo if you find it helpful!
