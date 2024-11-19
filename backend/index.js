import express from "express";
import cookieParser from "cookie-parser";
import path from 'path';

import authRoutes from './routes/auth.routes.js'
import messageRoutes from './routes/message.routes.js'
import userRoutes from './routes/user.routes.js'
import jwtRoutes from './routes/jwt.routes.js'
import connectToMongoDB from "./db/connectToMongoDB.js";
import cors from 'cors'

const app = express();
const PORT = process.env.PORT || 5000;

app.use(express.json());
app.use(cors())

connectToMongoDB();

app.get('/', (req, res) => {
    res.send('chatting app backend hellos')
})


//routes
app.use("/api/auth", authRoutes)
app.use("/api/messages", messageRoutes)
app.use("/api/users", userRoutes)
app.use("/api/jwt", jwtRoutes)

app.listen(PORT, async () => {

});
