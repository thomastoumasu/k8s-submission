import axios from 'axios';
// const baseUrl = 'http://localhost:3000/api/todos';
const baseUrl = import.meta.env.VITE_BACKEND_URL;

const getAll = () => {
  console.log('fetching todos from: ', baseUrl);
  const request = axios.get(baseUrl);
  return request.then(response => response.data);
};

const create = async newObject => {
  const response = await axios.post(baseUrl, newObject);
  return response.data;
};

export default {
  getAll,
  create,
};
