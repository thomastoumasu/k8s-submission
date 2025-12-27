const NATS = require('nats');
const nc = NATS.connect({
  url: process.env.NATS_URL || 'nats://nats:4222',
});

let preoccupied = false;

const setReadyToBroadcast = () => {
  const data_subscription = nc.subscribe('new_todos', { queue: 'broadcaster.workers' }, msg => {
    console.log('broadcaster received msg:', msg);
    preoccupied = true;
    nc.unsubscribe(data_subscription);
    broadcastTodo(JSON.parse(msg));
  });
  preoccupied = false;
};

const broadcastTodo = async ({ text }) => {
  console.log('Processing...');
  // await simpleWait(Math.random() * 10000)  // Some serious data processing happens here
  // const fullnames = data.map(person => ({ id: person.uuid, name: `${person.fn} ${person.ln}` }))
  // const payload = {
  //   index: index,
  //   data: fullnames
  // }
  // sendProcessedData(payload)
};

const sendProcessedData = payload => {
  nc.publish('saver_data', JSON.stringify(payload));
  console.log('Data was sent');
  setReadyToBroadcast();
};

setReadyToBroadcast();
console.log('Broadcaster listening');
