import jwt from "jsonwebtoken";
import dotenv from 'dotenv'
// import { decryptData, encryptData } from "../encryption/encryption.js";
dotenv.config();

const generateToken = (req, res) => {
    const accessToken = process.env.JWT_SECRET;

    const user = req.body  //decryptData(req.body);

    const token = jwt.sign(
        user,
        accessToken,
        { expiresIn: '24h' });

    // const encryptedToken = encryptData(token);

    console.log(token)

    res.send({token});
}

export default generateToken;