import 'dotenv/config';

const PORT = process.env.BACKEND_PORT || 3000;
const MONGODB_URI = process.env.MONGODB_URI || 'localhost';

export { PORT, MONGODB_URI };
