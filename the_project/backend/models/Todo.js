import mongoose from 'mongoose';

const todoSchema = new mongoose.Schema({
  text: String,
});

const Todo = mongoose.model('Todo', todoSchema);

export { Todo };
