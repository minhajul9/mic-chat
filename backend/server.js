import express from "express";
import dotenv from "dotenv";
import authRoutes from './routes/auth.routes.js'

const app = express();
const PORT = process.env.PORT || 5000;
dotenv.config();


app.get('/', (req, res) =>{
    res.send('chatting app backend')
})


//routes

//auth routes
app.use("/api/auth", authRoutes)

app.listen(PORT, () => console.log('Running on port: ', PORT));