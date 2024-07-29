import jwt from "jsonwebtoken";
import User from "../models/user.model.js";

const protectRoute = async (req, res, next) => {
    try {
        const token = req.cookies['mic-chat-token'];

        console.log("token");

        if (!token) {
            return res.status(401).json({ error: "Unauthorized access" })
        }

        const decoded = jwt.verify(token, process.env.JWT_SECRET);

        if (!decoded) {
            return res.status(401).json({ error: "Unauthorized access : Invalid Token" })
        }

        const user = await User.findById(decoded.userId).select("-password")

        if (!user) {
            return res.status(401).json({ error: "User not found" })
        }

        req.user = user;

        next();

    } catch (error) {
        console.log("Error from send protect route: ", error.message);
        res.status(500).json({ error: "Internal server error." })
    }
}

export default protectRoute;