import User from "../models/user.model.js";
import bcrypt from "bcryptjs";
import generateTokenAndSetCookie from "../utils/generateToken.js";

export const signup = async (req, res) => {
    try {
        const { fullName, username, gender, password } = req.body;

        const user = await User.findOne({ username })

        if (user) {
            return res.status(400).json({ error: true, message: "Username already exist!" })
        }
        const salt = await bcrypt.genSalt(10)
        const hashedPassword = await bcrypt.hash(password, salt)

        const boyAvatar = `https://avatar.iran.liara.run/public/boy?username=${username}`
        const girlAvatar = `https://avatar.iran.liara.run/public/girl?username=${username}`

        const newUser = new User({
            fullName,
            username,
            gender,
            password: hashedPassword,
            profilePic: gender === 'male' ? boyAvatar : girlAvatar
        })

        if (newUser) {
            await newUser.save();
            generateTokenAndSetCookie(newUser._id, res);

            res.status(201).json({
                _id: newUser._id,
                fullName: newUser.fullName,
                username: newUser.username,
                gender: newUser.gender,
                profilePic: newUser.profilePic
            })
        }

    } catch (error) {
        console.log("error in signup controller", error.message);
        res.status(500).json({ error: true, message: "Internal server error" })
    }
}


export const login = async (req, res) => {
    try {

        const { username, password } = req.body;

        const user = await User.findOne({ username });

        const isPasswordMatched = await bcrypt.compare(password, user?.password || "");
        if (!user || !isPasswordMatched) {
            res.send({ error: true, message: "Invalid username or password" })
        }

        else {
            generateTokenAndSetCookie(user._id, res);

            res.send({
                _id: user._id,
                fullName: user.fullName,
                username: user.username,
                gender: user.gender,
                profilePic: user.profilePic
            })
        }

    } catch (error) {
        console.log("error in login controller", error.message);
        res.send({ error: true, message: "Internal server error" });
    }
}

export const logout = (req, res) => {
    try {

        res.cookie("mic-chat-token", "", { maxAge: 0 });
        res.status(200).json({ message: "Logged out successfully." })

    } catch (error) {
        console.log("error in logout controller", error.message);
        res.status(500).json({ error: "Internal server error" })
    }
}