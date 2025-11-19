const express = require('express');
const { openai } = require('@ai-sdk/openai');
const { anthropic } = require('@ai-sdk/anthropic');
const { generateText } = require('ai');
const cors = require('cors');
const helmet = require('helmet');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 8080;

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'healthy', 
    timestamp: new Date().toISOString(),
    service: 'bizcap-ai-service'
  });
});

// AI generation endpoint
app.post('/api/ai/generate', async (req, res) => {
  try {
    const { prompt, provider = 'openai', model = 'gpt-4-turbo' } = req.body;
    
    if (!prompt) {
      return res.status(400).json({ error: 'Prompt is required' });
    }

    let aiProvider;
    if (provider === 'openai') {
      aiProvider = openai(process.env.OPENAI_API_KEY);
    } else if (provider === 'anthropic') {
      aiProvider = anthropic(process.env.ANTHROPIC_API_KEY);
    } else {
      return res.status(400).json({ error: 'Invalid provider' });
    }

    const { text } = await generateText({
      model: aiProvider(model),
      prompt,
      maxTokens: 1000,
    });

    res.json({ response: text });
  } catch (error) {
    console.error('AI generation error:', error);
    res.status(500).json({ error: 'Failed to generate response' });
  }
});

// Start server
app.listen(PORT, () => {
  console.log(`Bizcap AI Service running on port ${PORT}`);
});