import express from 'express';
import { VERSION, PORT } from './utils/config.js';

console.log(`Greeter app, version ${VERSION}: started`);

const app = express();
app.use(express.json());

app.get('/health', async (_req, res) => {
  // health check ensuring that the app deployed is in a functional state.
  console.log('Received a request to health');
  return res.sendStatus(200);
});

app.get('/', async (_req, res) => {
  res.send(`Hello from version ${VERSION}`);
});

app.listen(PORT, () => {
  console.log(`server started in port ${PORT}`);
});
