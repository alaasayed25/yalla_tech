const functions = require("firebase-functions");
const { GoogleGenerativeAI } = require("@google/generative-ai");

// ⚠️ حط API KEY هنا مؤقتًا
const genAI = new GoogleGenerativeAI("PUT_YOUR_API_KEY_HERE");

exports.analyze = functions.https.onRequest(async (req, res) => {
  try {
    const model = genAI.getGenerativeModel({
      model: "gemini-1.5-flash",
    });

    const prompt = req.body.prompt;

    const result = await model.generateContent(prompt);
    const response = result.response.text();

    res.json({ result: response });
  } catch (error) {
    console.error(error);
    res.status(500).send("Error");
  }
});