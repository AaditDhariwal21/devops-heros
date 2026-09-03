const express = require("express");
const app = express();

app.get("/", (req, res) => {
  res.send("<h1>Hello World from Node.js!</h1>");
});

app.listen(3000, () => console.log("Node app running on port 3000"));
