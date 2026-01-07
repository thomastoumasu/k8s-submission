import 'dotenv/config';

const PINGPONG_URL = process.env.PINGPONG_URL || 'http://localhost:3002/counter';
const GREETER_URL = process.env.GREETER_URL || 'http://localhost:3004/';
const PORT = process.env.PORT || 3000;
const MESSAGE = process.env.MESSAGE || 'no message';

export { PINGPONG_URL, GREETER_URL, PORT, MESSAGE };
