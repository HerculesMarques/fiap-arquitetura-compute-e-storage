const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('🚀 Aplicação rodando no ECS com Fargate!');
});

app.listen(port, () => {
  console.log(`Servidor iniciado na porta ${port}`);
});
