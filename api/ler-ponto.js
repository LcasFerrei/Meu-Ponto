// Vercel serverless function: lê a foto da batida usando a API do Gemini
// (tier gratuito). A chave nunca deve ir pro código do navegador — configure
// GEMINI_API_KEY nas Environment Variables do projeto no dashboard do Vercel.
export default async function handler(req, res) {
  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }

  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    res.status(500).json({ error: 'GEMINI_API_KEY não configurada no servidor.' });
    return;
  }

  const { mimeType, imageBase64, prompt } = req.body || {};
  if (!imageBase64 || !prompt) {
    res.status(400).json({ error: 'Faltam imageBase64 ou prompt no corpo da requisição.' });
    return;
  }

  try {
    const geminiRes = await fetch('https://generativelanguage.googleapis.com/v1beta/interactions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': apiKey,
      },
      body: JSON.stringify({
        model: 'gemini-3.5-flash',
        input: [
          { type: 'text', text: prompt },
          { type: 'image', data: imageBase64, mime_type: mimeType || 'image/jpeg' },
        ],
      }),
    });

    const data = await geminiRes.json();
    if (!geminiRes.ok) {
      res.status(geminiRes.status).json({ error: data.error?.message || 'Erro na API do Gemini', details: data });
      return;
    }

    res.status(200).json({ text: data.output_text || '' });
  } catch (err) {
    res.status(500).json({ error: 'Falha ao chamar a API do Gemini', details: String(err) });
  }
}
