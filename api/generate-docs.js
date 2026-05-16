// Vercel Serverless Function for AI Documentation Generator
// This keeps the Gemini API key secure on the backend

const { GoogleGenerativeAI } = require("@google/generative-ai");

module.exports = async (req, res) => {
  // Enable CORS for all origins (you can restrict this later)
  res.setHeader('Access-Control-Allow-Credentials', true);
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET,OPTIONS,PATCH,DELETE,POST,PUT');
  res.setHeader(
    'Access-Control-Allow-Headers',
    'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version'
  );

  // Handle preflight OPTIONS request
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  // Only allow POST requests
  if (req.method !== 'POST') {
    return res.status(405).json({ 
      success: false, 
      error: 'Method not allowed. Use POST.' 
    });
  }

  try {
    // Get API key from environment variable (set in Vercel dashboard)
    const apiKey = process.env.GEMINI_API_KEY;
    
    if (!apiKey) {
      throw new Error('GEMINI_API_KEY environment variable not configured');
    }

    // Initialize Gemini AI
    const genAI = new GoogleGenerativeAI(apiKey);
    const model = genAI.getGenerativeModel({
      model: "gemini-1.5-flash",
    });

    // Get prompt from request body
    const { prompt } = req.body;
    
    if (!prompt) {
      return res.status(400).json({
        success: false,
        error: 'Prompt is required in request body',
      });
    }

    console.log('Generating content for prompt length:', prompt.length);

    // Generate content using Gemini
    const result = await model.generateContent(prompt);
    const response = result.response.text();

    console.log('Content generated successfully');

    // Return success response
    return res.status(200).json({
      success: true,
      data: response,
    });

  } catch (error) {
    console.error('Error generating documentation:', error);

    return res.status(500).json({
      success: false,
      error: error.message || error.toString(),
    });
  }
};

// Made with Bob
