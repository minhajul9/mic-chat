import express from "express";
import dotenv from "dotenv";
import cookieParser from "cookie-parser";
import path from 'path';

import authRoutes from './routes/auth.routes.js'
import messageRoutes from './routes/message.routes.js'
import userRoutes from './routes/user.routes.js'


import connectToMongoDB from "./db/connectToMongoDB.js";
import { app, server } from "./socket/socket.js";

// const app = express();
const PORT = process.env.PORT || 5004;
// const _dirname = path.resolve();

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

// app.use(express.static(path.join(_dirname, "/frontend/dist")))

// app.get("*", (req, res) => { 
//     res.sendFile(path.join(_dirname, "frontend", "dist", "index.html"))
// })


server.listen(PORT, () => {
    connectToMongoDB();
    console.log('Running on port: ', PORT)
});
