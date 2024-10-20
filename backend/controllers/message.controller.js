import Conversation from "../models/conversation.model.js";
import Message from "../models/message.model.js";

export const sendMessage = async (req, res) => {
    try {
        const { message } = req.body;
        const receiverId = req.params.id;
        const senderId = req.user._id

        let conversation = await Conversation.findOne({
            participants: { $all: [senderId, receiverId] }
        })

        if (!conversation) {
            conversation = await Conversation.create({
                participants: [senderId, receiverId]
            })
        }

        const newMessage = new Message({
            senderId,
            receiverId,
            message
        })

        if (newMessage) {
            await newMessage.save();
            conversation.messages.push(newMessage._id);
            await conversation.save();
        }

        res.status(201).json(newMessage)


    } catch (error) {
        console.log("Error from send message controller: ", error.message);
        res.status(500).json({ error: "Internal server error." })
    }
}

export const getMessages = async (req, res) => {
    try {

        const { id: userToChatId } = req.params;
        const senderId = req.user._id;

        const conversation = await Conversation.findOne({
            participants: {
                $all: [senderId, userToChatId]
            }
        }).populate('messages')

        res.status(200).json(conversation);
    } catch (error) {
        console.log("Error from send message controller: ", error.message);
        res.status(500).json({ error: "Internal server error." })
    }
}
