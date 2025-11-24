const OutputEvery5s = (someString) => {
  console.log(`${new Date().toISOString()}: ${someString}`);

  setTimeout(OutputEvery5s, 5000, someString);
};

const randomString = Math.random().toString(36);
OutputEvery5s(randomString);
