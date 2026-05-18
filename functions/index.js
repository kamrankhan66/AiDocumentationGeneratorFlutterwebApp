const functions = require("firebase-functions");
const cors = require("cors")({ origin: true });
const { GoogleGenerativeAI } = require("@google/generative-ai");

// Set global options for cost control
const { setGlobalOptions } = require("firebase-functions/v2");
setGlobalOptions({ maxInstances: 10 });

/**
 * Generate Documentation using Gemini AI
 * Secure backend function - API key never exposed to frontend
 */
exports.generateDocs = functions
  .runWith({
    secrets: ["GEMINI_API_KEY"],
    timeoutSeconds: 540, // 9 minutes (max for HTTP functions)
    memory: "1GB",
  })
  .https.onRequest(async (req, res) => {
    cors(req, res, async () => {
      try {
        // Only allow POST requests
        if (req.method !== "POST") {
          return res.status(405).json({
            success: false,
            error: "Method not allowed. Use POST.",
          });
        }

        // Get API key from secret
        const apiKey = process.env.GEMINI_API_KEY;

        if (!apiKey) {
          throw new Error("GEMINI_API_KEY not configured");
        }

        // Initialize Gemini AI
        const genAI = new GoogleGenerativeAI(apiKey);
        const model = genAI.getGenerativeModel({
          model: "gemini-3.1-flash-lite",
        });

        // Get prompt from request body
        const { prompt } = req.body;

        if (!prompt) {
          return res.status(400).json({
            success: false,
            error: "Prompt is required in request body",
          });
        }

        // Generate content
        const result = await model.generateContent(prompt);
        const response = result.response.text();

        // Return success response
        res.status(200).json({
          success: true,
          data: response,
        });
      } catch (error) {
        console.error("Error generating docs:", error);

        res.status(500).json({
          success: false,
          error: error.toString(),
        });
      }
    });
  });

/**
 * Health check endpoint
 */
exports.healthCheck = functions.https.onRequest((req, res) => {
  res.status(200).json({
    status: "healthy",
    timestamp: new Date().toISOString(),
    service: "AI Documentation Generator",
  });
});

// Made with Bob
