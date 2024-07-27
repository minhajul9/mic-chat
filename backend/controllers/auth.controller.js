import User from "../models/user.model.js";
import bcrypt from "bcryptjs";

export const signup = async (req, res) => {
    try {
        const { fullName, username, gender, password } = req.body;

        const user = await User.findOne({ username })

        if (user) {
            return res.status(400).json({ error: "Username already exist!" })
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

        await newUser.save();

        res.status(201).json({
            _id: newUser._id,
            fullName: newUser.fullName,
            username: newUser.username,
            gender: newUser.gender,
            profilePic: newUser.profilePic
        })

    } catch (error) {
        console.log("error in signup controller", error.message);
        res.status(500).json({ error: "Internal server error" })
    }
}

export const login = (req, res) => {
    console.log("login user");
}

export const logout = (req, res) => {
    console.log('log out');
}