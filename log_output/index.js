import Koa from 'koa';
import path from 'path';
import fs from 'fs';

const PORT = process.env.PORT || 3000;
const randomString = Math.random().toString(36);

const directory = path.join('/', 'usr', 'src', 'app', 'files');
// const directory = '../logs/';
const filePath = path.join(directory, 'counter.txt');

const app = new Koa();

const getFile = async () =>
  new Promise(res => {
    fs.readFile(filePath, { encoding: 'utf-8' }, (err, buffer) => {
      if (err) {
        console.log('FAILED TO READ LOG FILE', '-------', err);
        return res(0);
      }
      console.log('could read log file, counter is: ', Number(buffer));
      return res(Number(buffer));
    });
  });

app.use(async ctx => {
  if (ctx.path.includes('favicon.ico')) return;
  const counter = await getFile();
  ctx.body = `${new Date().toISOString()}: ${randomString} \nPing / Pongs: ${counter}`;
  ctx.set('Content-type', 'text/plain');
  ctx.status = 200;
});

app.listen(PORT, () => {
  console.log(`Log-output app: server started in port ${PORT}`);
});
