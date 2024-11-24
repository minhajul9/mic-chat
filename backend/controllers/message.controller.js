import Conversation from "../models/conversation.model.js";
import Message from "../models/message.model.js";
import { getReceiverSocketId, io } from "../socket/socket.js";
import { ObjectId } from 'mongodb'

export const sendMessage = async (req, res) => {
    try {
        const message = req.body;
        const conversationId = req.params.id;
        const senderId = req.decoded._id
        const receiverId = message.receiverId;

        let conversation = await Conversation.findById(conversationId)
        console.log(conversation)

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
            conversation.lastMessageTime = new Date();
            conversation.lastMessage = newMessage.message;

            // conversation.save();
        }

        await Promise.all([conversation.save(), newMessage.save()])

        //socket-io
        const receiverSocketId = getReceiverSocketId(receiverId);
        if (receiverSocketId) {
            io.to(receiverSocketId).emit("newMessage", newMessage)
        }

        res.status(201).json({ message: newMessage, conversation, error: false })


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

        res.json({ message: newMessage, conversation, error: false })


    } catch (error) {
        console.log("Error from send message controller: ", error.message);
        res.json({ error: true, message: "Internal server error." })
    }
}

export const getMessages = async (req, res) => {
    try {

        let messages;

        const conversationId = new ObjectId(req.params.id);
        const conversation = await Conversation.findById(conversationId);
        // console.log(conversation);

        if (!conversation) return res.status(200).json({ error: false, messages: [] });

        else {
            messages = await Message.find({ conversationId: conversationId });
            // console.log(messages);
        }

        res.status(200).json({ error: false, messages });
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

        if (!conversation) return res.status(200).json({ messages: [], conversation: null });
        const messages = await Message.find({
            conversationId: conversation._id
        })

        res.status(200).json({ messages, conversation, error: false });
    } catch (error) {
        console.log("Error from send message controller: ", error.message);
        res.status(500).json({ error: true, message: "Internal server error." })
    }
}
