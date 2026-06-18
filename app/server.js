const express = require('express');
const fs = require('fs');

const app = express();
const port = process.env.PORT || 8080;

//ConfigMap example
const configValue = process.env.APP_CONFIG || "default-config";

//Secret from Key Vault (mounted as file)
const secretPath = "/mnt/secrets-store/mysecret";

app.get('/health', (req, res) => {
  res.json({ status: "ok" });  
});

app.get('/config', (req, res) => {
  res.json({ config: configValue });
});

app.get('/secret', (req, res) => {
  try {
    const secret = fs.readFileSync(secretPath, 'utf8');
    res.json({ secret: secret.trim() });
  } catch (err) {
    res.status(500).json({ error: "Secret not found." });
  }
});

app.listen(port, () => {
  console.log('API running on port ${port}');  
});
