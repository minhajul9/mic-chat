import Conversation from "../models/conversation.model.js";
import Message from "../models/message.model.js";
import { getReceiverSocketId, io } from "../socket/socket.js";

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
            conversationId: conversation._id,
            message
        })

        if (newMessage) {


            conversation.isRead = false;
            conversation.lastMessageTime = new Date.now();
            conversation.lastMessage = newMessage.message;

            // conversation.save();
        }

        await Promise.all([conversation.save(), newMessage.save()])

        //socket-io
        const receiverSocketId = getReceiverSocketId(receiverId);
        if (receiverSocketId) {
            console.log("new message called")
            io.to(receiverSocketId).emit("newMessage", newMessage)
        }

        res.status(201).json(newMessage)


    } catch (error) {
        console.log("Error from send message controller: ", error.message);
        res.status(500).json({ error: true, message: "Internal server error." })
    }
}

export const sendFirstMessage = async (req, res) => {
    try {

        const message = req.body;
        console.log("sending first message: ", message)
        const receiverId = message.receiverId;
        const senderId = req.decoded._id;

        const senderName = message.senderName;
        delete message.senderName;

        let newConversation = false;

        let conversation = await Conversation.findOne({
            participants: { $all: [senderId, receiverId] }
        })

        if (!conversation) {
            newConversation = true;
            conversation = await Conversation.create({
                participants: [senderId, receiverId]
            })
        }

        const newMessage = await Message.create({
            senderId,
            receiverId,
            conversationId: conversation._id,
            message: message.message
        })

        if (newMessage) {


            conversation.isRead = false;
            conversation.lastMessageTime = new Date();
            conversation.lastMessage = newMessage.message;

            // conversation.save();
        }

        await Promise.all([conversation.save(), newMessage.save()])

        //socket-io
        // const receiverSocketId = getReceiverSocketId(receiverId);
        // if (receiverSocketId) {
        //     console.log("new message called")
        //     io.to(receiverSocketId).emit("newMessage", newMessage)
        // }

        res.status(201).json({ message: newMessage, conversation, error: false })


    } catch (error) {
        console.log("Error from send message controller: ", error.message);
        res.status(500).json({ error: true, message: "Internal server error." })
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

        if (!conversation) return res.status(200).json([]);

        res.status(200).json(conversation?.messages);
    } catch (error) {
        console.log("Error from send message controller: ", error.message);
        res.status(500).json({ error: true, message: "Internal server error." })
    }
}

export const checkMessages = async (req, res) => {
    try {

        const { id } = req.params;
        const senderId = req.decoded._id;

        const conversation = await Conversation.findOne({
            participants: {
                $all: [senderId, id]
            }
        })

        if (!conversation) return res.status(200).json({ messages: [] });
        const messages = await Message.find({
            conversationId: conversation._id
        })

        res.status(200).json({ messages, conversation, error: false });
    } catch (error) {
        console.log("Error from send message controller: ", error.message);
        res.status(500).json({ error: true, message: "Internal server error." })
    }
}
