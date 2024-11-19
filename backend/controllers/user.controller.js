import Conversation from "../models/conversation.model.js";
import User from "../models/user.model.js";
import { ObjectId } from 'mongodb';

export const getUsersForSidebar = async (req, res) => {
    try {

        const loggedInUser = req.user._id;

        const filteredUsers = await User.find({ _id: { $ne: loggedInUser } }).select('-password');

        res.status(200).json(filteredUsers);
    } catch (error) {
        console.log("error in signup controller", error.message);
        res.status(500).json({ error: true, message: "Internal server error" })
    }
}

export const getConversations = async (req, res) => {
    try {

        const userId = new ObjectId(req.params.userId);

        // console.log(userId);

        const conversations = await Conversation.aggregate([
            {
                $match: {
                    participants: userId
                }
            },
            {
                $unwind: "$participants"
            },
            {
                $match: {
                    participants: { $ne: userId } // Exclude the requesting user
                }
            },
            {
                $lookup: {
                    from: "users", // The name of the users collection
                    localField: "participants",
                    foreignField: "_id",
                    as: "participantDetails"
                }
            },
            {
                $unwind: "$participantDetails"
            },
            {
                $group: {
                    _id: "$_id",
                    participants: { $push: "$participantDetails" },
                    conversationData: { $first: "$$ROOT" }
                }
            }
        ]);



        res.send(conversations)
    } catch (error) {
        console.log(error)
    }
}
