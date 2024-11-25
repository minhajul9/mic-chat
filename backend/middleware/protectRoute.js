import jwt from "jsonwebtoken";
import User from "../models/user.model.js";

const protectRoute = async (req, res, next) => {
    const authorization = req.headers.authorization;



    if (!authorization) {
        return res.status(401).send({ timeOut: true, error: true, message: 'unauthorized access' });
    }

    const token = authorization.split(' ')[1];
    jwt.verify(token, process.env.JWT_SECRET, (error, decoded) => {

        if (error) {
            return res.send({ timeOut: true, error: true, message: 'Session Time out.' });
        }


        req.decoded = decoded;
        next();
    })
}

export default protectRoute;