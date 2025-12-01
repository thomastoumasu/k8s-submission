import express from 'express';
import fs from 'fs';
import path from 'path';

const PORT = process.env.PORT || 3002;

const fileAlreadyExists = async () =>
  new Promise(res => {
    fs.stat(filePath, (err, stats) => {
      if (err || !stats) return res(false);
      return res(true);
    });
  });

const findAFile = async () => {
  if (await fileAlreadyExists()) return;
  await new Promise(res => fs.mkdir(directory, err => res()));
};

const initCounter = async () =>
  new Promise(res => {
    fs.readFile(filePath, { encoding: 'utf-8' }, (err, buffer) => {
      if (err) {
        console.log('FAILED TO READ LOG FILE', '-------', err, '\nreset counter');
        return res(0);
      }
      console.log('COULD READ LOG FILE', 'counter is: ', Number(buffer));
      return res(Number(buffer));
    });
  });

// define path to log file
const directory = path.join('/', 'usr', 'src', 'app', 'files');
// const directory = '../logs/';
const filePath = path.join(directory, 'counter.txt');

console.log('Pingpong app: started');
// create the directory if the log file does not exist
await findAFile();

// initialize counter from the log file or with 0 if no file is found
let counter = await initCounter();

const app = express();
app.use(express.json());

app.get('/pingpong', (_req, res) => {
  counter += 1;
  res.send(`pong ${counter}`);
  fs.writeFile(filePath, String(counter), err => {
    if (err) {
      console.log('FAILED TO WRITE TO LOG FILE', '-------', err);
    } else {
      console.log(`wrote ${counter} to log file`);
    }
  });
});

app.listen(PORT, () => {
  console.log(`server started in port ${PORT}`);
});
