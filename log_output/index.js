import express from 'express';

const PORT = process.env.PORT || 3000;
const randomString = Math.random().toString(36);

const app = express();
app.use(express.json());

app.get('/', (_req, res) => {
  res.send(`${new Date().toISOString()}: ${randomString}`);
});

app.listen(PORT, () => {
  console.log(`server started in port ${PORT}`);
});
