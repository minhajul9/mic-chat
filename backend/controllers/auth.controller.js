import User from "../models/user.model.js";
import bcrypt from "bcryptjs";
import generateToken from "../utils/generateToken.js";
import { getConversations } from "./user.controller.js";
import { ObjectId } from 'mongodb'

export const signup = async (req, res) => {
    try {
        const { fullName, username, gender, password } = req.body;

        const user = await User.findOne({ username })

        if (user) {
            return res.send({ error: true, message: "Username already exist!" })
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
        // generateToken(newUser._id, res);

        console.log(newUser);


        res.send({
            _id: newUser._id,
            fullName: newUser.fullName,
            username: newUser.username,
            gender: newUser.gender,
            profilePic: newUser.profilePic
        });


    } catch (error) {
        console.log("error in signup controller", error.message);
        res.status(500).json({ error: true, message: "Internal server error" })
    }
}

export const login = async (req, res) => {
    try {

        const { username, password } = req.body;

        const user = await User.findOne({ username });
        if (!user) {
            res.send({ error: true, message: "Invalid username or password" })
        }

        else {
            const isPasswordMatched = await bcrypt.compare(password, user?.password);
            if (!user || !isPasswordMatched) {
                res.send({ error: true, message: "Invalid username or password" })
            }
            else {

                res.send({
                    _id: user._id,
                    fullName: user.fullName,
                    username: user.username,
                    gender: user.gender,
                    profilePic: user.profilePic
                })
            }


        }

    } catch (error) {
        console.log("error in login controller\n\n\n", error);
        res.send({ error: true, message: "Internal server error" });
    }
}

export const logout = async (req, res) => {
    try {

        const id = req.decoded._id;
        const user = await User.findById(id);

        user.fcmToken = '';
        await user.save();
        res.status(200).json({ error: false, message: "Logged out successfully." })

    } catch (error) {
        console.log("error in logout controller", error.message);
        res.status(500).json({ error: true, message: "Internal server error" })
    }
}

export const loadUserData = async (req, res) => {
    try {
        const id = req.decoded._id;

        const _id = new ObjectId(id);
        const user = await User.findById(id).lean();

        res.send({
            _id: user._id,
            fullName: user.fullName,
            username: user.username,
            gender: user.gender,
            profilePic: user.profilePic
        })
    } catch (error) {

        console.log("error in load user data", error);
        res.send({ error: true, message: "Server error." })

    }
}