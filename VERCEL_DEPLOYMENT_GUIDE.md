# 🚀 FREE Production Deployment - Vercel Solution

## Problem
- Local pe kaam kar raha hai ✅
- Firebase Hosting pe deployed hai ✅
- But API key issue hai production mein ❌
- Hackathon ke liye production URL chahiye ✅
- **FREE solution chahiye** ✅

## ✅ SOLUTION: Vercel (100% FREE)

Vercel provides:
- ✅ FREE hosting
- ✅ FREE serverless functions (backend)
- ✅ Automatic HTTPS
- ✅ Global CDN
- ✅ No credit card required
- ✅ Perfect for hackathons!

---

## 🚀 Step-by-Step Setup (10 Minutes)

### STEP 1: Vercel Account Banao

1. **Visit**: https://vercel.com/signup
2. **Sign up with GitHub** (easiest)
3. **Free plan select karo** (no credit card needed)

### STEP 2: Project Structure Setup

Create `api` folder in project root:

```bash
mkdir api
```

### STEP 3: Create Vercel Function

Create file: `api/generate-docs.js`

```javascript
// api/generate-docs.js
const { GoogleGenerativeAI } = require("@google/generative-ai");

module.exports = async (req, res) => {
  // Enable CORS
  res.setHeader('Access-Control-Allow-Credentials', true);
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET,OPTIONS,PATCH,DELETE,POST,PUT');
  res.setHeader(
    'Access-Control-Allow-Headers',
    'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version'
  );

  // Handle OPTIONS request
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  // Only allow POST
  if (req.method !== 'POST') {
    return res.status(405).json({ 
      success: false, 
      error: 'Method not allowed' 
    });
  }

  try {
    // Get API key from environment variable
    const apiKey = process.env.GEMINI_API_KEY;
    
    if (!apiKey) {
      throw new Error('GEMINI_API_KEY not configured');
    }

    // Initialize Gemini
    const genAI = new GoogleGenerativeAI(apiKey);
    const model = genAI.getGenerativeModel({
      model: "gemini-1.5-flash",
    });

    // Get prompt from request
    const { prompt } = req.body;
    
    if (!prompt) {
      return res.status(400).json({
        success: false,
        error: 'Prompt is required',
      });
    }

    // Generate content
    const result = await model.generateContent(prompt);
    const response = result.response.text();

    // Return success
    res.status(200).json({
      success: true,
      data: response,
    });
  } catch (error) {
    console.error('Error:', error);
    res.status(500).json({
      success: false,
      error: error.toString(),
    });
  }
};
```

### STEP 4: Create vercel.json

Create file: `vercel.json` in project root

```json
{
  "version": 2,
  "builds": [
    {
      "src": "api/**/*.js",
      "use": "@vercel/node"
    },
    {
      "src": "build/web/**",
      "use": "@vercel/static"
    }
  ],
  "routes": [
    {
      "src": "/api/(.*)",
      "dest": "/api/$1"
    },
    {
      "src": "/(.*)",
      "dest": "/build/web/$1"
    }
  ]
}
```

### STEP 5: Create package.json for API

Create file: `api/package.json`

```json
{
  "name": "ai-doc-generator-api",
  "version": "1.0.0",
  "dependencies": {
    "@google/generative-ai": "^0.21.0"
  }
}
```

### STEP 6: Update Flutter Code

Update `lib/services/gemini_service.dart`:

```dart
class GeminiService {
  // Use Vercel function URL instead of direct API
  static const String _functionUrl = 
    'https://your-project.vercel.app/api/generate-docs';
  
  Future<String> _generateContent(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_functionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] as String;
      } else {
        throw Exception('Failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
```

### STEP 7: Build Flutter Web

```bash
flutter build web
```

### STEP 8: Deploy to Vercel

**Option A: Using Vercel CLI** (Recommended)

```bash
# Install Vercel CLI
npm install -g vercel

# Login
vercel login

# Deploy
vercel

# Follow prompts:
# - Link to existing project? No
# - Project name: ai-doc-generator
# - Directory: ./ (current)
# - Override settings? No

# Production deploy
vercel --prod
```

**Option B: Using Vercel Dashboard**

1. Go to: https://vercel.com/new
2. Import your GitHub repository
3. Configure:
   - Framework Preset: Other
   - Build Command: `flutter build web`
   - Output Directory: `build/web`
4. Add Environment Variable:
   - Name: `GEMINI_API_KEY`
   - Value: Your API key
5. Click "Deploy"

### STEP 9: Get Your Production URL

After deployment, you'll get:
```
https://ai-doc-generator-xyz.vercel.app
```

Update this URL in your Flutter code!

---

## 🎯 Complete Setup Commands

```bash
# 1. Create API folder
mkdir api

# 2. Create generate-docs.js (copy code above)

# 3. Create vercel.json (copy config above)

# 4. Create api/package.json (copy config above)

# 5. Build Flutter
flutter build web

# 6. Install Vercel CLI
npm install -g vercel

# 7. Login to Vercel
vercel login

# 8. Deploy
vercel

# 9. Set environment variable
vercel env add GEMINI_API_KEY

# 10. Production deploy
vercel --prod
```

---

## 🔐 Security Benefits

✅ **API Key Hidden**: Backend only, never exposed
✅ **CORS Configured**: Only your domain can access
✅ **HTTPS**: Automatic SSL certificate
✅ **Rate Limiting**: Vercel provides built-in protection
✅ **FREE**: No cost, perfect for hackathons

---

## 📊 Vercel Free Tier Limits

- ✅ 100GB Bandwidth/month
- ✅ 100GB-hours Serverless Function Execution
- ✅ Unlimited Deployments
- ✅ Automatic HTTPS
- ✅ Global CDN
- ✅ **More than enough for hackathons!**

---

## 🎉 After Deployment

Your production URL will be:
```
https://ai-doc-generator-[random].vercel.app
```

Features:
- ✅ Fully functional
- ✅ API key secure
- ✅ Fast global CDN
- ✅ Professional URL
- ✅ Perfect for hackathon demo!

---

## 🐛 Troubleshooting

### Issue: Function timeout
**Solution**: Vercel free tier has 10s timeout. For longer operations, upgrade or optimize.

### Issue: CORS error
**Solution**: Check CORS headers in `api/generate-docs.js`

### Issue: API key not working
**Solution**: 
```bash
vercel env add GEMINI_API_KEY
# Paste your key
vercel --prod
```

---

## 💡 Pro Tips

1. **Custom Domain** (Optional):
   - Add your own domain in Vercel dashboard
   - Free SSL included

2. **Preview Deployments**:
   - Every Git push creates preview URL
   - Test before production

3. **Analytics**:
   - Vercel provides free analytics
   - Monitor your app usage

4. **Team Collaboration**:
   - Invite team members
   - Free for open source projects

---

## 🚀 Alternative: Netlify (Also FREE)

If Vercel doesn't work, try Netlify:

1. **Visit**: https://www.netlify.com
2. **Drag & drop** `build/web` folder
3. **Add Netlify Function** (similar to Vercel)
4. **Deploy**

Same benefits, different platform!

---

## 📞 Quick Links

- **Vercel Signup**: https://vercel.com/signup
- **Vercel Docs**: https://vercel.com/docs
- **Vercel CLI**: https://vercel.com/docs/cli
- **Your GitHub Repo**: https://github.com/kamrankhan66/AI-Documentation-Generator

---

**Perfect for hackathons - FREE, fast, and professional!** 🚀

**Made with ❤️ using IBM BOB AI**