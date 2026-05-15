# 🔑 Google Gemini API Key Setup Guide

## Error: "PERMISSION_DENIED - Method doesn't allow unregistered callers"

This error occurs when the API key is not properly configured in Google Cloud Console.

## Solution: Complete API Key Setup

### Step 1: Get a New API Key

1. **Go to Google AI Studio**
   - Visit: https://makersuite.google.com/app/apikey
   - Or: https://aistudio.google.com/app/apikey

2. **Create New API Key**
   - Click "Create API Key"
   - Select "Create API key in new project" (recommended)
   - Or select an existing Google Cloud project
   - Copy the generated API key

3. **Important**: Save this key securely - you won't be able to see it again!

### Step 2: Configure API Key Restrictions (IMPORTANT!)

1. **Go to Google Cloud Console**
   - Visit: https://console.cloud.google.com/apis/credentials
   - Select your project from the dropdown

2. **Find Your API Key**
   - Click on the API key you just created
   - You'll see the "Edit API key" page

3. **Set Application Restrictions**
   
   **For Web App (Deployed on Firebase/Web):**
   - Select "HTTP referrers (web sites)"
   - Add your website URLs:
     ```
     https://ai-doc-generator-2026.web.app/*
     https://ai-doc-generator-2026.firebaseapp.com/*
     http://localhost:*
     ```
   
   **For Development (Local Testing):**
   - Select "None" (less secure but works for testing)
   - OR add `http://localhost:*` to HTTP referrers

4. **Set API Restrictions**
   - Select "Restrict key"
   - Check ONLY: **"Generative Language API"**
   - This ensures the key can only be used for Gemini API

5. **Save Changes**
   - Click "Save" at the bottom

### Step 3: Enable Required APIs

1. **Go to API Library**
   - Visit: https://console.cloud.google.com/apis/library
   
2. **Enable Generative Language API**
   - Search for "Generative Language API"
   - Click on it
   - Click "Enable"
   - Wait for it to be enabled (takes a few seconds)

### Step 4: Update Your Project

1. **Update .env File**
   ```bash
   # Open .env file
   # Replace with your NEW API key
   GEMINI_API_KEY=AIzaSyAE7yrMuRlfeDGPHarPDI9Ee2VUEzIUmGQ
   ```

2. **Restart Your App**
   ```bash
   # Stop the running app (Ctrl+C)
   # Clear Flutter cache
   flutter clean
   
   # Get dependencies
   flutter pub get
   
   # Run again
   flutter run -d chrome
   ```

### Step 5: Test the API Key

Create a test file to verify:

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> testGeminiAPI() async {
  final apiKey = 'YOUR_API_KEY_HERE';
  final url = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent?key=$apiKey'
  );
  
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': 'Say hello!'}
          ]
        }
      ]
    }),
  );
  
  print('Status: ${response.statusCode}');
  print('Response: ${response.body}');
}
```

## Common Issues & Solutions

### Issue 1: "API key not valid"
**Solution**: 
- Make sure you copied the entire key
- Check for extra spaces
- Regenerate the key if needed

### Issue 2: "PERMISSION_DENIED"
**Solution**:
- Enable "Generative Language API" in Google Cloud Console
- Wait 5-10 minutes for changes to propagate
- Check API restrictions are set correctly

### Issue 3: "Quota exceeded"
**Solution**:
- Check your quota: https://console.cloud.google.com/apis/api/generativelanguage.googleapis.com/quotas
- Free tier: 60 requests per minute
- Upgrade to paid plan if needed

### Issue 4: "API key expired"
**Solution**:
- API keys don't expire unless you delete them
- If revoked, create a new one
- Update .env file with new key

## Security Best Practices

### ✅ DO:
1. **Use API Key Restrictions**
   - Always restrict by HTTP referrer for web apps
   - Restrict to specific APIs only

2. **Use Environment Variables**
   - Never hardcode API keys
   - Use .env files (excluded from Git)

3. **Monitor Usage**
   - Check Google Cloud Console regularly
   - Set up billing alerts

4. **Rotate Keys Regularly**
   - Create new keys every few months
   - Delete old unused keys

### ❌ DON'T:
1. Don't commit API keys to Git
2. Don't share keys in public channels
3. Don't use production keys in development
4. Don't leave keys unrestricted

## For Firebase Hosting

If deploying to Firebase, add these referrers:

```
https://YOUR-PROJECT-ID.web.app/*
https://YOUR-PROJECT-ID.firebaseapp.com/*
```

Replace `YOUR-PROJECT-ID` with your actual Firebase project ID.

## Billing & Quotas

### Free Tier Limits:
- **Requests**: 60 per minute
- **Tokens**: 1 million per month
- **Models**: gemini-pro, gemini-pro-vision

### Paid Tier:
- Higher rate limits
- More models available
- Better support

Check pricing: https://ai.google.dev/pricing

## Troubleshooting Checklist

- [ ] API key is correct and complete
- [ ] .env file exists and is loaded
- [ ] Generative Language API is enabled
- [ ] API restrictions are set correctly
- [ ] HTTP referrers include your domain
- [ ] Waited 5-10 minutes after making changes
- [ ] Cleared Flutter cache and rebuilt
- [ ] No billing issues in Google Cloud Console

## Support Links

- **Google AI Studio**: https://aistudio.google.com
- **API Documentation**: https://ai.google.dev/docs
- **Cloud Console**: https://console.cloud.google.com
- **Pricing**: https://ai.google.dev/pricing
- **Support**: https://support.google.com/cloud

---

**Still having issues?**
1. Check Google Cloud Console for error details
2. Verify billing is enabled (if using paid features)
3. Try creating a completely new API key
4. Contact Google Cloud Support

**Last Updated**: 2026-05-15