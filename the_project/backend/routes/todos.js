import { info } from '../utils/logger.js';
import { Todo } from '../models/Todo.js';
import express from 'express';
const router = express.Router();

router.get('/', async (req, res) => {
  const todos = await Todo.find({});
  res.send(todos);
  console.log('todos: ', todos);
});

router.post('/', async (req, res) => {
  const newTodo = req.body;
  info(`--server: received post request for: ${JSON.stringify(newTodo)}`);
  if (newTodo.text.length > 140) {
    info('--server: Todo too long. Cannot create Todo.');
    return res.status(400).json({
      error: 'Todo too long',
    });
  } else {
    const todo = await Todo.create({
      text: newTodo.text,
    });
    res.send(todo);
    info(`--server: so created following Todo: ${JSON.stringify(todo)}`);
  }
});

export default router;
