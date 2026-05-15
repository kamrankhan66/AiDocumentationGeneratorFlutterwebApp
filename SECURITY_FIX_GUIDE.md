# Security Fix Guide - API Key Leak Resolution

## Problem
The Gemini API key was accidentally committed to the GitHub repository, making it publicly visible.

## Solution Implemented

### 1. Environment Variables Setup ✅
- Created `.env` file to store API key securely
- Created `.env.example` as a template
- Updated `.gitignore` to exclude `.env` files

### 2. Code Changes ✅
- Added `flutter_dotenv` package to `pubspec.yaml`
- Updated `lib/core/constants/app_constants.dart` to read from environment variables
- Modified `lib/main.dart` to load `.env` file on startup

### 3. Remove API Key from Git History

**IMPORTANT:** The old API key is still in Git history. You need to:

#### Option A: Remove from Git History (Recommended)
```bash
# Install git-filter-repo (if not installed)
# Windows: pip install git-filter-repo
# Mac: brew install git-filter-repo

# Remove the file from history
git filter-repo --path lib/core/constants/app_constants.dart --invert-paths --force

# Or use BFG Repo-Cleaner (easier)
# Download from: https://rtyley.github.io/bfg-repo-cleaner/
java -jar bfg.jar --replace-text passwords.txt
git reflog expire --expire=now --all && git gc --prune=now --aggressive

# Force push to GitHub
git push origin --force --all
```

#### Option B: Revoke and Create New API Key (HIGHLY RECOMMENDED)
1. Go to Google AI Studio: https://makersuite.google.com/app/apikey
2. **Delete the old API key** (AIzaSyDIxlQguDyin3o1Ki57zxU5esqcJvjaroM)
3. Create a new API key
4. Update `.env` file with new key
5. Never commit `.env` file

### 4. Setup Instructions for Team Members

When cloning the repository:

```bash
# Clone the repo
git clone https://github.com/kamrankhan66/AI-Documentation-Generator.git
cd AI-Documentation-Generator

# Copy the example env file
cp .env.example .env

# Edit .env and add your API key
# GEMINI_API_KEY=your_actual_api_key_here

# Install dependencies
flutter pub get

# Run the app
flutter run -d chrome
```

## Security Best Practices

### ✅ DO:
- Store sensitive keys in `.env` files
- Add `.env` to `.gitignore`
- Use environment variables
- Provide `.env.example` as template
- Revoke compromised keys immediately
- Use API key restrictions in Google Cloud Console

### ❌ DON'T:
- Hardcode API keys in source code
- Commit `.env` files to Git
- Share API keys in chat/email
- Use production keys in development
- Ignore security warnings from GitHub

## GitHub Security Alert

If GitHub detected the leaked key:
1. Go to repository Settings → Security → Secret scanning alerts
2. Review the alert
3. Mark as "Revoked" after creating new key
4. Close the alert

## API Key Restrictions (Recommended)

In Google Cloud Console:
1. Go to APIs & Services → Credentials
2. Click on your API key
3. Add restrictions:
   - **Application restrictions**: HTTP referrers (websites)
   - **Website restrictions**: Add your domains
   - **API restrictions**: Restrict to Generative Language API only

## Monitoring

- Enable GitHub secret scanning
- Set up alerts for exposed secrets
- Regularly rotate API keys
- Monitor API usage in Google Cloud Console

---

**Status:** 
- ✅ Code fixed with environment variables
- ⚠️ Old key still in Git history
- ⚠️ Need to revoke old key and create new one
- ⚠️ Need to force push to remove from history

**Next Steps:**
1. Revoke old API key immediately
2. Create new API key
3. Update `.env` with new key
4. Remove old key from Git history (optional but recommended)
5. Force push changes to GitHub