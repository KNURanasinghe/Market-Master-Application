require('dotenv').config();
const express = require('express');
const app = express();
const userRouter = require('./routes/user.route');
const cors = require('cors');

app.use(cors());
app.use(express.json());
app.use("/api/users", userRouter);

const PORT = process.env.APP_PORT || 3000;
app.listen(PORT, () => {
    console.log("Server Up and Running PORT:", PORT);
});
