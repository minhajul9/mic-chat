import express from "express";
import dotenv from "dotenv";
import cookieParser from "cookie-parser";

import authRoutes from './routes/auth.routes.js'
import messageRoutes from './routes/message.routes.js'
import userRoutes from './routes/user.routes.js'


import connectToMongoDB from "./db/connectToMongoDB.js";
import { app, server } from "./socket/socket.js";

// const app = express();
const PORT = process.env.PORT || 5004;
dotenv.config();

app.use(express.json());
app.use(cookieParser());


app.get('/', (req, res) => {
    res.send('chatting app backend')
})


//routes

//auth routes
app.use("/api/auth", authRoutes)
app.use("/api/messages", messageRoutes)
app.use("/api/users", userRoutes)


server.listen(PORT, () => {
    connectToMongoDB();
    console.log('Running on port: ', PORT)
});
